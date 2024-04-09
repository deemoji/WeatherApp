import Foundation
import RxSwift
import RxCocoa

protocol WeatherUseCase {
    func weather() -> Single<Weather.Responce>
}
