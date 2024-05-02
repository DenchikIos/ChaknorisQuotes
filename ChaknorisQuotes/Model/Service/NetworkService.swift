import Foundation

final class JokeFromNetwork {
    
    func downloadJoke(categoryName: String?, completionHandler: ((_ result: JokeCodable?)-> Void)?) {
        var urlRequest = URL(string: JokeFromNetworkURL.random.rawValue)!
        if let categoryName = categoryName {
            urlRequest = URL(string: JokeFromNetworkURL.categoryName.rawValue + "\(categoryName)")!
        }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("ERROR: \(error)")
                completionHandler?(nil)
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode != 200 {
                print("ERROR StatusCode: \(String(describing: statusCode)) \n")
                completionHandler?(nil)
                return
            }
            
            guard let data = data else { return print("Данные по ссылке \(urlRequest) не получены") }
            do {
                let result = try JSONDecoder().decode(JokeCodable.self, from: data)
                completionHandler?(result)
            } catch {
                print("Error for catch: \(error.localizedDescription)")
                completionHandler?(nil)
            }
        }
        dataTask.resume()
    }
    
    func downloadAllCategories(categories: URL?, completionHandler: ((_ result: JokeCodable?)-> Void)?) {
        guard let urlRequest = URL(string: JokeFromNetworkURL.random.rawValue) else {return}
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("ERROR: \(error)")
                completionHandler?(nil)
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode != 200 {
                print("ERROR StatusCode: \(String(describing: statusCode)) \n")
                completionHandler?(nil)
                return
            }
            
            guard let data = data else { return print("Данные по ссылке \(urlRequest) не получены") }
            do {
                let result = try JSONDecoder().decode(JokeCodable.self, from: data)
                completionHandler?(result)
            } catch {
                print("Error for catch: \(error.localizedDescription)")
                completionHandler?(nil)
            }
        }
        dataTask.resume()
    }
    
    func fetchData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.unowned))
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let value = try decoder.decode(T.self, from: data)
                            completion(.success(value))
                        } catch {
                            completion(.failure(.decodeError))
                        }
                    }
                case 404:
                    completion(.failure(.notFound))
                case 500:
                    completion(.failure(.serverError))
                default:
                    assertionFailure("unowned status code = \(response.statusCode)")
                    completion(.failure(.unowned))
                }
            }
        }
        dataTask.resume()
    }
    
    func request(url: URL?, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let url = url else {return}
        let session = URLSession.shared
        let task = session.dataTask(with: url) {data, response, error in
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                completion(.failure(.unowned))
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        do {
                            guard let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String] else { return }
                            completion(.success(jsonDictionary))
                        } catch {
                            print("Ошибка обработки JSON: \(error.localizedDescription)")
                            completion(.failure(.decodeError))
                        }
                    }
                case 404:
                    completion(.failure(.notFound))
                default:
                    break
                }
            }
        }
        task.resume()
    }
    
}
