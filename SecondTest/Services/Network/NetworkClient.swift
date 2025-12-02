import Foundation

protocol NetworkClientProtocol {
    var host: String { get }
    func send<T: ApiRequestProtocol>(request: T, completion: @escaping (Result<[T.Response], ApiClientError>) -> Void)
}

struct NetworkClient: NetworkClientProtocol {
    let host: String
    
    init(host: String) {
        self.host = host
    }
    
    func send<T: ApiRequestProtocol>(request: T, completion: @escaping (Result<[T.Response], ApiClientError>) -> Void) {
        guard let request = request.makeRequest(host: host) else {
            main(.failure(ApiClientError.request), completion)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                main(.failure(ApiClientError.network), completion)
                return
            }
            
            guard let data = data else {
                main(.failure(ApiClientError.empty), completion)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                main(.failure(ApiClientError.service(httpResponse.statusCode)), completion)
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let result = try? decoder.decode([T.Response].self, from: data) else {
                main(.failure(ApiClientError.deserialize), completion)
                return
            }
            
            main(.success(result), completion)
        }
        task.resume()
    }
    
    private func main<T>(_ value: T, _ completion: @escaping (T) -> Void) {
        DispatchQueue.main.async {
            completion(value)
        }
    }
}


