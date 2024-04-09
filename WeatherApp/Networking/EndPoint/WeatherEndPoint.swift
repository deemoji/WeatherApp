import Foundation

enum WeatherEndPoint: EndPointType {
    
    case weatherByAddress(unitGroup: String, address: String)
    
    case weatherByCoordinate(unitGroup: String, latitide: Double, longitude: Double)
    
    var baseURL: URL  {
        guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/") else {
            fatalError("BaseURL cannot be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .weatherByAddress(_, let address):
            return address
        case .weatherByCoordinate(_, let latitide, let longitude):
            return "\(latitide),\(longitude)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .weatherByAddress(let unitGroup, _), .weatherByCoordinate(let unitGroup, _, _):
            return .requestWithParameters(bodyParameters: nil, urlParameters: ["unitGroup": unitGroup, "key": Keys.apiKey.rawValue])
        default:
            return .request
        }
    }
    
}
