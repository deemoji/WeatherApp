import UIKit


final class HourlyItemCell: UICollectionViewCell {
    
    static let identifier: String = "HourlyWeatherCell"
    
    private let hourlyWeatherStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .center
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemBackground.withAlphaComponent(0.5) : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
        
        contentView.addSubview(hourlyWeatherStackView)
        NSLayoutConstraint.activate([
            hourlyWeatherStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            hourlyWeatherStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
            hourlyWeatherStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            hourlyWeatherStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        hourlyWeatherStackView.addArrangedSubview(hourLabel)
        hourlyWeatherStackView.addArrangedSubview(weatherImageView)
        hourlyWeatherStackView.addArrangedSubview(temperatureLabel)
    }
    
}
// MARK: - Binding a ViewModel
extension HourlyItemCell {
    func bind(_ viewModel: HourlyItemViewModel) {
        hourLabel.text = viewModel.hour
        temperatureLabel.text = viewModel.temp
        weatherImageView.image = UIImage(named: "colored/" + viewModel.icon)
    }
    
}
