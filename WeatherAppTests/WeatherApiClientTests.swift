import XCTest
import Network
@testable import WeatherApp

class WeatherApiClientTests: XCTestCase {

    var sut: WeatherNetwork!
    
    override func setUpWithError() throws {
        sut = WeatherNetwork()
    }
    override func tearDownWithError() throws {
        sut = nil
    }

    func testGenerationRequest() throws {        
        let url = try XCTUnwrap(URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/56.438410,2038.251600?unitGroup=metric&key=LF7RV8CHLECR4BQ3LTQ38AW9R&contentType=json"))
        let request = try sut.makeRequest(requestData: Weather.RequestType.latitudeLongitude("56.438410", "2038.251600"), with: .metric)
        
        XCTAssertEqual(url, request.url)
    }
    func testSuccessfulResponce() throws {
        // given
        let requestData = Weather.RequestType.latitudeLongitude("56.438410", "2038.251600")
        var result: Weather.Responce?
        let expectation = expectation(description: "Waiting for responce call to complete.")
        
        // when
        let _ = sut.fetchWeather(requestData, with: .metric).subscribe { responce in
            result = responce
            expectation.fulfill()
        } onFailure: { error in
            if let error = error as? Network.RequestError {
                switch error {
                case .badStatusCode(let statusCode):
                    XCTFail("Error with status code - \(statusCode)")
                break
                }
            }
            XCTFail(error.localizedDescription)
        }
        
        // then
        waitForExpectations(timeout: 6) { error in
            guard let result = result else {
                XCTFail()
                return
            }
            XCTAssertEqual(result.address, "56.438410,38.251600")
        }
    }
    
    


}
