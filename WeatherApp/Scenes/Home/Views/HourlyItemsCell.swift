import UIKit
import RxSwift

final class HourlyItemsCell: UITableViewCell {

    static let identifier: String = "HourlyItemsCell"
    
    private var lastScrollPosition = CGPoint.zero
    private var selectedItem: Int = 0
    
    private var bag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.register(HourlyItemCell.self, forCellWithReuseIdentifier: HourlyItemCell.identifier)
        
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    func reuseCollectionViewState() {
        collectionView.setContentOffset(lastScrollPosition, animated: false)
        collectionView.selectItem(at: IndexPath(item: selectedItem, section: 0), animated: false, scrollPosition: .bottom)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        lastScrollPosition = collectionView.contentOffset
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension HourlyItemsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.item
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height - 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
   
}

extension HourlyItemsCell {
    func bind(_ viewModel: HourlyItemsViewModel) {
        let output = viewModel.transform(HourlyItemsViewModel.Input(hourSelected: collectionView.rx.itemSelected.asDriver()))
        output.refreshing.drive(onNext: { [unowned self] in
            if($0) {
                selectedItem = 0
                lastScrollPosition = CGPoint.zero
            }
        }).disposed(by: bag)
        output.hourlyWeather.drive(collectionView.rx.items(cellIdentifier: HourlyItemCell.identifier, cellType: HourlyItemCell.self)) { [unowned self] index, model, cell in
            if (index == selectedItem) { cell.isSelected = true }
            cell.bind(model)
        }.disposed(by: bag)
    }
}
