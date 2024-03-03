import UIKit

final class ParamView: UIView {

    let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.backgroundColor = UIColor(named: "secondary")?.withAlphaComponent(0.2)
        addSubview(stackView)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(nameLabel)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: self.centerYAnchor),
            valueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            valueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
