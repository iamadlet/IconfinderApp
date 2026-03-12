import UIKit

enum IconSaveError: Error {
    case downloadFailed
    case accessDenied
    case saveFailed
}

protocol IconSaveServiceProtocol: AnyObject {
    func saveIcon(from urlString: String, completion: @escaping (Result<Void, IconSaveError>) -> Void)
}

final class IconSaveService: IconSaveServiceProtocol {
    private let imageDownloadService: ImageDownloadServiceProtocol
    private let photoLibraryService: PhotoLibraryServiceProtocol
    
    init(
        imageDownloadService: ImageDownloadServiceProtocol,
        photoLibraryService: PhotoLibraryServiceProtocol
    ) {
        self.imageDownloadService = imageDownloadService
        self.photoLibraryService = photoLibraryService
    }
    
    func saveIcon(from urlString: String, completion: @escaping (Result<Void, IconSaveError>) -> Void) {
        imageDownloadService.downloadImage(from: urlString) { [weak self] result in
            guard let self else { return }
            
            switch result {
                
            case .success(let image):
                self.photoLibraryService.save(image: image) { saveResult in
                    switch saveResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        switch error {
                        case .accessDenied:
                            completion(.failure(.accessDenied))
                        case .saveFailed:
                            completion(.failure(.saveFailed))
                        }
                    }
                }
                
            case .failure:
                completion(.failure(.downloadFailed))
            }
        }
    }
}
