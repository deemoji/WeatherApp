import UIKit
import RxSwift
import RxCocoa

final class SelectedHourlyItemCell: UITableViewCell {
    
    static let identifier: String = "SelectedHourlyItemCell"
    private let bag = DisposeBag()
    
    private let backgorundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        return view
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Day.Cloudy")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 79, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let paramsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        sv.spacing = 10
        sv.axis = .horizontal
        return sv
    }()
    private let windView: ParamView = {
        let pv = ParamView()
        pv.iconView.image = UIImage(named: "windMini")
        pv.nameLabel.text = "Wind"
        pv.valueLabel.text = "-"
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    private let humidityView: ParamView = {
        let pv = ParamView()
        pv.iconView.image = UIImage(named: "humidityMini")
        pv.nameLabel.text = "Humidity"
        pv.valueLabel.text = "-"
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    private let rainChanceView: ParamView = {
        let pv = ParamView()
        pv.iconView.image = UIImage(named: "rainMini")
        pv.nameLabel.text = "Precipitations"
        pv.valueLabel.text = "-"
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(backgorundView)
        NSLayoutConstraint.activate([
            backgorundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            backgorundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            backgorundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            backgorundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        contentView.addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            weatherImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            weatherImageView.topAnchor.constraint(equalTo: self.topAnchor),
            weatherImageView.rightAnchor.constraint(equalTo: self.centerXAnchor),
            weatherImageView.bottomAnchor.constraint(equalTo: backgorundView.centerYAnchor, constant: -10)
        ])
        
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            temperatureLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            temperatureLabel.leftAnchor.constraint(equalTo: self.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: backgorundView.centerYAnchor, constant: -10)
        ])
        
        contentView.addSubview(paramsStackView)
        
        NSLayoutConstraint.activate([
            paramsStackView.rightAnchor.constraint(equalTo: backgorundView.rightAnchor, constant: -30),
            paramsStackView.leftAnchor.constraint(equalTo: backgorundView.leftAnchor, constant: 30),
            paramsStackView.bottomAnchor.constraint(equalTo: backgorundView.bottomAnchor, constant: -30),
            paramsStackView.topAnchor.constraint(equalTo: backgorundView.centerYAnchor, constant: 0)
        ])
        paramsStackView.addArrangedSubview(windView)
        paramsStackView.addArrangedSubview(humidityView)
        paramsStackView.addArrangedSubview(rainChanceView)
        rainChanceView.widthAnchor.constraint(equalTo: windView.widthAnchor).isActive = true
        humidityView.widthAnchor.constraint(equalToConstant: 65).isActive = true
    }
}
// MARK: - Binding a ViewModel
extension SelectedHourlyItemCell {
    func bind(_ viewModel: Driver<HourlyItemViewModel>) {
        viewModel.drive(onNext: { [unowned self] in
            temperatureLabel.text = $0.temp
            windView.valueLabel.text = $0.wind
            humidityView.valueLabel.text = $0.humidity
            rainChanceView.valueLabel.text = $0.precipProbability
            weatherImageView.image = UIImage(named: "white/" + $0.icon)
        }).disposed(by: bag)
    }
}
