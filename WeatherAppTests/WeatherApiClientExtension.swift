import Foundation
@testable import WeatherApp
import XCTest

extension WeatherApiClient {
    func makeRequest(requestData: Weather.RequestType, with unit: Weather.Unit) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path + requestData.directory
        components.queryItems = [
            URLQueryItem(name: "unitGroup", value: unit.rawValue),
            URLQueryItem(name: "key", value: Keys.apiKey.rawValue),
            URLQueryItem(name: "contentType", value: "json")
        ]
        let url = try XCTUnwrap(components.url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
