import UIKit

enum ImageDownloadError: Error {
    case invalidURL
    case invalidData
    case network(Error)
}

protocol ImageDownloadServiceProtocol: AnyObject {
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, ImageDownloadError>) -> Void)
}

final class ImageDownloadService: ImageDownloadServiceProtocol {
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, ImageDownloadError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, _, error in
            if let error {
                completion(.failure(.network(error)))
                return
            }
            
            guard let data, let image = UIImage(data: data) else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(image))
        }.resume()
    }
}
