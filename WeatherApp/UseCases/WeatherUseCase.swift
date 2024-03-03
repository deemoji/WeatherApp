import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol WeatherUseCase {
    func weather() -> Single<Weather.Responce>
}

final class QueryWeatherUseCase: WeatherUseCase {
    
    private let network: WeatherApiClient
    private let city: String
    
    init(network: WeatherApiClient, city: String) {
        self.network = network
        self.city = city
    }
    
    func weather() -> Single<Weather.Responce> {
        return network.fetchWeather(Weather.RequestType.address(city), with: .metric)
    }
}

final class CoreLocationWeatherUseCase: WeatherUseCase {
    
    enum CoreLocationWeatherUseCaseError: Error {
        case locationNotDefined
        case geocoderError
    }
    
    private let network: WeatherApiClient
    private var locationManager: CLLocationManager
    
    init(network: WeatherApiClient, locationManager: CLLocationManager) {
        self.network = network
        self.locationManager = locationManager
        
    }
    
    func weather() -> Single<Weather.Responce> {
        locationManager.requestWhenInUseAuthorization()
        let errorObservable = locationManager.rx.didFailWithError.flatMap { error in
            Observable<[CLLocation]>.create { observer in
                observer.onError(error)
                return Disposables.create()
            }
        }
        
        return locationManager.rx.didUpdateLocations
            .amb(errorObservable)
            .map { $0.last }
            .unwrap()
            .take(1)
            .do(onSubscribe: { [weak self] in
                self?.locationManager.startUpdatingLocation()
            },
                onDispose: { [weak self] in
                self?.locationManager.stopUpdatingLocation()
            })
            .asSingle()
            .flatMap { [unowned self] in getLocality(from: $0) }
            .flatMap { [unowned self] in network.fetchWeather(.address($0), with: .metric) }
    }
    private func getLocality(from location: CLLocation) -> Single<String> {
        Single<String>.create { single in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let placemarks = placemarks,
                      let placemark = placemarks.first,
                      let locality = placemark.locality else {
                    single(.failure(CoreLocationWeatherUseCaseError.geocoderError))
                    return
                }
                
                single(.success(locality))
            }
            return Disposables.create()
        }
    }
}
