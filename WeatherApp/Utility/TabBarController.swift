import UIKit

final class TabBarController: UITabBarController {
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        let colorTop = UIColor(red: 41/255, green: 45/255, blue: 69/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 23/255, green: 23/255, blue: 38/255, alpha: 1.0).cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0,1]
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layer = CAShapeLayer()
        let rect = CGRect(x: 30, y: self.tabBar.bounds.minY, width: self.tabBar.bounds.width - 60, height: self.tabBar.bounds.height + 10)
        layer.path = UIBezierPath(roundedRect: rect, cornerRadius: 17).cgPath
        layer.cornerRadius = 17
        layer.frame = self.tabBar.bounds
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
        gradientLayer.frame = rect
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.tintColor = .systemPink
        self.tabBar.itemWidth = 30
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = rect.width / 6
    }
}
