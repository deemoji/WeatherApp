import UIKit

final class CityCell: UITableViewCell {
    
    public static let identifier = "CityCell"
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .left
        label.text = "-"
        label.textColor = .white
        return label
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
        contentView.backgroundColor = .white.withAlphaComponent(0.1)
        layer.cornerRadius = 17
        layer.masksToBounds = true
        backgroundColor = .clear
        
        contentView.addSubview(cityNameLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cityNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            cityNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(_ city: String) {
        cityNameLabel.text = city
    }
}
