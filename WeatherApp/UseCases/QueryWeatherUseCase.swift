import Foundation
import RxSwift

final class QueryWeatherUseCase: WeatherUseCase {
    
    private let network: WeatherNetwork
    private let city: String
    
    init(network: WeatherNetwork, city: String) {
        self.network = network
        self.city = city
    }
    
    func weather() -> Single<Weather.Responce> {
        return network.fetchWeather(city, .metric)
    }
}
