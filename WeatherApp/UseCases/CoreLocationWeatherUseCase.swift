import Foundation
import CoreLocation
import RxSwift

enum CoreLocationWeatherUseCaseError: String, Error {
    case locationUnknown = "The location is unknown. Please try again."
    case denied = "The access to your location is denied. You can change it in Settings."
    case network = "Connection error. Please check for internet connection."
    case unknown = "Unknown error."
    
    static func from(_ error: CLError) -> CoreLocationWeatherUseCaseError {
        switch error.code {
        case .locationUnknown:
            return .locationUnknown
        case .denied:
            return .denied
        case .network:
            return .network
        default:
            return .unknown
        }
    }
}

extension CoreLocationWeatherUseCaseError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(self.rawValue, comment: "CoreLocationWeatherUseCaseError")
    }
}
final class CoreLocationWeatherUseCase: WeatherUseCase {
    
    private let network: WeatherNetwork
    private var locationManager: CLLocationManager
    
    init(network: WeatherNetwork, locationManager: CLLocationManager) {
        self.network = network
        self.locationManager = locationManager
        
    }
    
    func weather() -> Single<Weather.Responce> {
        
        locationManager.requestWhenInUseAuthorization()
        let errorObservable = locationManager.rx.didFailWithError.flatMap { error in
            Observable<[CLLocation]>.create { observer in
                if let error = error as? CLError {
                    observer.onError(CoreLocationWeatherUseCaseError.from(error))
                } else {
                    observer.onError(error)
                }
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
            .flatMap { [unowned self] in network.fetchWeather($0, .metric) }
    }
    private func getLocality(from location: CLLocation) -> Single<String> {
        Single<String>.create { single in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error as? CLError {
                    single(.failure(CoreLocationWeatherUseCaseError.from(error)))
                    return
                }
                if let error = error {
                    print(error.localizedDescription)
                    single(.failure(CoreLocationWeatherUseCaseError.unknown))
                    return
                }
                guard let placemarks = placemarks,
                      let placemark = placemarks.first,
                      let locality = placemark.locality else {
                    single(.failure(CoreLocationWeatherUseCaseError.unknown))
                    return
                }
                
                single(.success(locality))
            }
            return Disposables.create()
        }
    }
}
