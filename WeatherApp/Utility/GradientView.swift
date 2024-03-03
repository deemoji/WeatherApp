import UIKit

final class GradientView: UIView {

    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    private let firstGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let secondGredientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        let colorTop = UIColor(named: "gradient")!.cgColor
        let colorBottom = UIColor(named: "background-primary")!.cgColor
        layer.colors = [colorTop, colorBottom]
        layer.locations = [0.0, 0.44]
        layer.type = .radial
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()
    private let secondGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        let colorTop = UIColor(red: 0/255, green: 141/255, blue: 255/255, alpha: 1).cgColor
        let colorBottom = UIColor.clear.cgColor
        gradient.colors = [colorTop,colorBottom]
        gradient.locations = [0.0,0.75]
        gradient.startPoint = CGPoint(x: 0.8, y: -0.1)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        firstGradientView.layer.insertSublayer(gradient, at: 0)
        addSubview(firstGradientView)
        firstGradientView.addSubview(secondGredientView)
        secondGredientView.layer.insertSublayer(secondGradient, at: 0)
        firstGradientView.addSubview(blurEffectView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        firstGradientView.frame = self.bounds
        gradient.frame = firstGradientView.bounds
        secondGredientView.frame = firstGradientView.bounds
        secondGradient.frame = secondGredientView.bounds
        blurEffectView.frame = firstGradientView.bounds
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if(traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
            let colorTop = UIColor(red: 255/255, green: 81/255, blue: 165/255, alpha: 1).cgColor
            let colorBottom = UIColor(named: "background-primary")!.cgColor
            gradient.colors = [colorTop, colorBottom]
        }
    }
}
