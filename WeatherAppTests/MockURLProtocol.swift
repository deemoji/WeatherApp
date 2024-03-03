import Foundation
@testable import WeatherApp

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {}
    
    
}
final class MockURLSession: URLSessionProtocol {
    enum MockError: String, Error {
        case UrlError
    }
    var data: Data?
    var responce: HTTPURLResponse?
    var error: Error?
    
    var dataTask = MockURLSessionDataTask()
    
    private(set) var url: URL?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTaskProtocol {
        url = request.url
        completionHandler(data,responce,error)
        return dataTask
    }
    
    
}
