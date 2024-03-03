import UIKit

final class DailyItemCell: UITableViewCell {
    
    static let identifier: String = "DailyItemCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Friday"
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "colored/clear-day")
        return iv
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10C"
        return label
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10C"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemPink : .clear
        }
    }
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .center
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    private let tempStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .center
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fillEqually
        return sv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(weatherImageView)
        stackView.addArrangedSubview(tempStackView)
        tempStackView.addArrangedSubview(UIView()) // Temp labels gets closer to each other
        tempStackView.addArrangedSubview(maxTempLabel)
        tempStackView.addArrangedSubview(minTempLabel)
    }
    
}
extension DailyItemCell {
    func bind(_ viewModel: DailyItemViewModel) {
        dayLabel.text = viewModel.weekday
        weatherImageView.image = UIImage(named: "colored/" + viewModel.icon)
        maxTempLabel.text = viewModel.maxTemp
        minTempLabel.text = viewModel.minTemp
    }
}
