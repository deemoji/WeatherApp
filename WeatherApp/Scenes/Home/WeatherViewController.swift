import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class WeatherViewController: UIViewController {
    
    var viewModel: WeatherViewModel!
    private let bag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.contentInsetAdjustmentBehavior = .always
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        tableview.backgroundView = GradientView()
        tableview.register(HourlyItemsCell.self, forCellReuseIdentifier: HourlyItemsCell.identifier)
        tableview.register(SelectedHourlyItemCell.self, forCellReuseIdentifier: SelectedHourlyItemCell.identifier)
        tableview.register(DailyItemCell.self, forCellReuseIdentifier: DailyItemCell.identifier)
        return tableview
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Loading"
        tableView.delegate = self
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        assert(viewModel != nil)
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = refreshControl.rx.controlEvent(.valueChanged).asDriverOnErrorJustComplete()
        
        let output = viewModel.transform(WeatherViewModel.Input(
            refresh: Driver.merge(pull, viewWillAppear)))
        let dataSource = WeatherViewController.dataSource()
        output.items.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        output.location.drive { [unowned self] in navigationItem.title = $0 }.disposed(by: bag)

        output.error.drive(onNext: { [weak self] in
            self?.showErrorMessage($0.localizedDescription)
        }).disposed(by: bag)
        output.fetching.drive(refreshControl.rx.isRefreshing).disposed(by: bag)
    }
    
    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
}
// MARK: - RxDataSource
extension WeatherViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<WeatherSection> {
        RxTableViewSectionedReloadDataSource<WeatherSection>( configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .selectedItem(viewModel: let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectedHourlyItemCell.identifier) as! SelectedHourlyItemCell
                cell.bind(viewModel)
                return cell
            case .hourlyItem(viewModel: let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: HourlyItemsCell.identifier) as! HourlyItemsCell
                cell.bind(viewModel)
                // to reset state after reusing the cell
                cell.reuseCollectionViewState()
                return cell
            case .dailyItem(viewModel: let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: DailyItemCell.identifier) as! DailyItemCell
                cell.bind(viewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            switch dataSource[index] {
            case .hourly(_,_), .daily(_,_):
                return dataSource[index].title
            default:
                return nil
            }
        })
    }
}
// MARK: - UITableViewDelegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return tableView.frame.height * 0.35
        case 1: return tableView.frame.height * 0.2
        case 2: return tableView.frame.height * 0.05
        default: return UITableView.automaticDimension
        }
    }
}

