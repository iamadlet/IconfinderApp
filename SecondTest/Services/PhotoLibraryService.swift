import UIKit
import Photos

enum PhotoLibraryError: Error {
    case accessDenied
    case saveFailed
}

protocol PhotoLibraryServiceProtocol: AnyObject {
    func save(image: UIImage, completion: @escaping (Result<Void, PhotoLibraryError>) -> Void)
}

final class PhotoLibraryService: PhotoLibraryServiceProtocol {
    func save(image: UIImage, completion: @escaping (Result<Void, PhotoLibraryError>) -> Void) {
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch currentStatus {
        case .authorized, .limited:
            saveImage(image, completion: completion)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                switch status {
                case .authorized, .limited:
                    self.saveImage(image, completion: completion)
                default:
                    completion(.failure(.accessDenied))
                }
            }
            
        default:
            completion(.failure(.saveFailed))
        }
    }
    
    func saveImage(_ image: UIImage, completion: @escaping (Result<Void, PhotoLibraryError>) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, _ in
            if success {
                completion(.success(()))
            } else {
                completion(.failure(.saveFailed))
            }
        }
    }
}
