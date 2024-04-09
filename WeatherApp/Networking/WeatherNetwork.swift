import Foundation
import RxSwift

final class WeatherNetwork {
    
    private let network = Network<WeatherEndPoint>()
    
    func fetchWeather(_ address: String, _ unit: Weather.Unit) -> Single<Weather.Responce> {
        return network.executeQuery(endPoint: .weatherByAddress(unitGroup: unit.rawValue, address: address)).map { data in
            try JSONDecoder().decode(Weather.Responce.self, from: data)
        }
    }
}

