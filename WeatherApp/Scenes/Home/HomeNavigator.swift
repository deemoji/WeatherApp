import UIKit

protocol HomeNavigator {
    func toHome()
}

final class DefaultHomeNavigator: HomeNavigator {
    
    private let navigationController: UINavigationController
    private let services: WeatherUseCaseProvider
    
    
    init(navigationController: UINavigationController, services: WeatherUseCaseProvider) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func toHome() {
        let homeViewController = WeatherViewController()
        let vm = WeatherViewModel(useCase: services.makeWeatherUseCase())
        homeViewController.viewModel = vm
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
