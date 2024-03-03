import Foundation
import RxSwift

final class SingleRequest {
    enum RequestError: Error {
        case badStatusCode(Int)
    }
    private lazy var jsonDecoder = JSONDecoder()
    
    func get<ModelItem: Decodable>(urlRequest: URLRequest, urlSession: URLSessionProtocol) -> Single<ModelItem> {
        return Single.create { single in
            let task = urlSession.dataTask(with: urlRequest) { data, responce, error in
                if let error = error { single(.failure(error)) }
                if let responce = responce as? HTTPURLResponse {
                    let statusCode = responce.statusCode
                    
                    // if responce code is OK
                    if (200...399).contains(statusCode) {
                        // try parse fetched data and send it to sequence
                        do {
                            let data = data ?? Data()
                            let item = try self.jsonDecoder.decode(ModelItem.self, from: data)
                            single(.success(item))
                        } catch {
                            single(.failure(error))
                        }
                    } else {
                        single(.failure(RequestError.badStatusCode(statusCode)))
                    }
                }
            }
            task.resume()
            return Disposables.create() {
                task.cancel()
            }
        }
    }
}

final class WeatherApiClient {
    enum ApiClientError: String, Error {
        case apiKeyNotFound
        case urlBroken
    }
    
    let host = "weather.visualcrossing.com"
    let path = "/VisualCrossingWebServices/rest/services/timeline/"
    
    private var urlSession = URLSession.shared
    
    func fetchWeather(_ requestType: Weather.RequestType, with unit: Weather.Unit) -> Single<Weather.Responce> {
        guard let request = makeURLRequest(requestType, unit, Keys.apiKey.rawValue) else {
            return Single.error(ApiClientError.urlBroken)
        }
        return SingleRequest().get(urlRequest: request, urlSession: urlSession)
    }
    
    private func makeURLRequest(_ type: Weather.RequestType, _ unit: Weather.Unit, _ apiKey: String) -> URLRequest? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path + type.directory
        components.queryItems = [
            URLQueryItem(name: "unitGroup", value: unit.rawValue),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "contentType", value: "json")
        ]
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}

