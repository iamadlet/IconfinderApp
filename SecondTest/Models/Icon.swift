import Foundation

struct IconsListResponse: Decodable {
    let data: [IconResponse]
}

struct IconResponse: Decodable {
    let id: Int
    let name: String
    let thumbnails: [Thumbnail]
    let tags: [Tag]
}

struct Thumbnail: Decodable {
    let url: String
    let width: Int
    let height: Int
}

struct Tag: Decodable {
    let slug: String
    let name: String
}


struct IconRequest: ApiRequestProtocol {
    
    typealias Response = IconsListResponse
    
    var endpoint: String { "/v1/icons" }
    
    var parameters: [URLQueryItem]? {
        let result: [URLQueryItem] = [
            URLQueryItem(name: "term", value: term)
        ]
        return result
    }
    
    let term: String
    
    init(term: String) {
        self.term = term
    }
}

struct IconModel {
    let id: Int
    let width: String
    let height: String
    let imageURL: String
    let tags: [String]
}

extension IconModel {
    init?(response: IconResponse) {
        self.id = response.id
        guard let biggestSize = response.thumbnails.max(by: { $0.width < $1.width }) else {
            return nil
        }
        self.imageURL = response.thumbnails.first!.url
        self.tags = Array(response.tags.map { $0.slug }.prefix(10))
        self.width = String(biggestSize.width)
        self.height = String(biggestSize.height)
    }
    
    private func intToString(value: Int) -> String {
        return String(value)
    }
}
