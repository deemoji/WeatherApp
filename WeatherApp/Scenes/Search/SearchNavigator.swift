import Foundation
import UIKit

protocol SearchNavigator {
    func toSearch()
    func toWeather(city: String)
}

final class DefaultSearchNavigator: SearchNavigator {
    
    private let navigationController: UINavigationController
    private let useCaseProvider: SearchUseCaseProvider
    
    init(navigationController: UINavigationController, useCaseProvider: SearchUseCaseProvider) {
        self.navigationController = navigationController
        self.useCaseProvider = useCaseProvider
    }
    func toSearch() {
        let viewController = SearchViewController()
        let viewModel = SearchViewModel(useCaseProvider.makeUseCase(), navigator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toWeather(city: String) {
        let viewController = WeatherViewController()
        let useCaseProvider = QueryWeatherUseCaseProvider(city)
        let viewModel = WeatherViewModel(useCase: useCaseProvider.makeWeatherUseCase())
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
