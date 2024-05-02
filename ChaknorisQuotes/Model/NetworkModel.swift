import Foundation

enum JokeFromNetworkURL: String, CaseIterable {
    case categories = "https://api.chucknorris.io/jokes/categories"
    case random = "https://api.chucknorris.io/jokes/random"
    case categoryName = "https://api.chucknorris.io/jokes/random?category="
    
    var url: URL? {
            URL(string: self.rawValue)
        }
}

struct JokeCodable: Codable {
    let categories: [String]
    let id: String
    let value: String
}

enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case decodeError = 1000
    case serverError = 500
    case unowned = 2000
}
