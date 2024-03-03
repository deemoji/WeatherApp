import UIKit

final class Application {
    
    static let shared = Application()
    
    private let weatherProvider: WeatherUseCaseProvider
    private let searchProvider: SearchUseCaseProvider
    
    private init() {
        weatherProvider = CoreLocationUseCaseProvider()
        searchProvider = DefaultSearchUseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab-bar-icons/home"), selectedImage: nil)
        let homeNavigator = DefaultHomeNavigator(navigationController: homeNavigationController, services: weatherProvider)
        
        let searchNavigationController = UINavigationController()
        searchNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab-bar-icons/search"), selectedImage: nil)
        let searchNavigator = DefaultSearchNavigator(navigationController: searchNavigationController, useCaseProvider: searchProvider)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor(named: "gradient")
        tabBarController.viewControllers = [
            homeNavigationController,
            searchNavigationController
        ]
        window.rootViewController = tabBarController
        
        // instantiate new modules
        homeNavigator.toHome()
        searchNavigator.toSearch()
    }
}
