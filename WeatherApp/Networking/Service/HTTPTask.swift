import Foundation

enum HTTPTask {
    case request
    case requestWithParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestWithParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, headers: HTTPHeaders?)
}
