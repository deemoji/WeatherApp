import XCTest
import RxCocoa
import RxSwift
import RxBlocking
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    var mockSession: MockURLSession!
    var sut: Network!
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        sut = Network()
    }
    override func tearDownWithError() throws {
        mockSession = nil
        sut = nil
    }
    func testSuccessfulResponce() throws {
        // given
        let url = try XCTUnwrap(URL(string: "google.com"))
        let path = try XCTUnwrap(Bundle.main.url(forResource: "WeatherData", withExtension: "json"))
        
        let request = URLRequest(url: url)
        let responce = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        let single: Single<Weather.Responce> = sut.executeQuery(urlRequest: request, urlSession: mockSession)
        
        // when
        mockSession.data = try? Data(contentsOf: path)
        mockSession.responce = responce
        // then
        XCTAssertEqual(try single.toBlocking().single().address, "56.438410, 38.251600")
    }
    
    func testErrorResponce() throws {
        let request = URLRequest(url: URL(string: "google.com")!)
        let responce = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)
        mockSession.responce = responce
        mockSession.error = MockURLSession.MockError.UrlError
        let single: Single<Weather.Responce> = sut.executeQuery(urlRequest: request, urlSession: mockSession)
        let _ = single.subscribe(onFailure: { error in
            XCTAssertNotNil(error, "Error not fetched")
        }).dispose()
    }
    

}
