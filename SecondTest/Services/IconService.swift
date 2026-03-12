import Foundation

protocol IconServiceProtocol: AnyObject {
    func fetchIcons(request: IconRequest, completion: @escaping (Result<[IconModel], ApiClientError>) -> Void)
}

class IconService: IconServiceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchIcons(request: IconRequest, completion: @escaping (Result<[IconModel], ApiClientError>) -> Void) {
        networkClient.send(request: request) { (result: Result<IconsListResponse, ApiClientError>) in
            switch result {
            case .success(let listResponse):
                let models = listResponse.data.compactMap { IconModel(response: $0) }
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
