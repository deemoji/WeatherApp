import Foundation
import CoreLocation

protocol WeatherUseCaseProvider {
    func makeWeatherUseCase() -> WeatherUseCase
}
final class CoreLocationUseCaseProvider: WeatherUseCaseProvider {
    private let network = WeatherNetwork()
    private let locationManager = CLLocationManager()
    func makeWeatherUseCase() -> WeatherUseCase {
        if (!CLLocationManager.locationServicesEnabled())  {
            locationManager.requestWhenInUseAuthorization()
        }
        return CoreLocationWeatherUseCase(network: network, locationManager: locationManager)
    }
    
    
}
final class QueryWeatherUseCaseProvider: WeatherUseCaseProvider {
    private let city: String
    private let network = WeatherNetwork()
    
    init(_ city: String) {
        self.city = city
    }
    
    func makeWeatherUseCase() -> WeatherUseCase {
        return QueryWeatherUseCase(network: network, city: city)
    }
    
}
