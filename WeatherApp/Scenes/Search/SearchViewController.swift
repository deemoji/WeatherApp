import UIKit
import RxSwift

final class SearchViewController: UIViewController {

    var viewModel: SearchViewModel!
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Find your city..."
        sb.layer.cornerRadius = 15
        sb.searchTextField.textColor = .white
        return sb
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.backgroundView = GradientView()
        tv.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
        
        return tv
    }()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.navigationItem.titleView = searchBar
        tableView.delegate = self
        bindViewModel()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func bindViewModel() {
        assert(viewModel != nil)
        let output = viewModel.transform(SearchViewModel.Input(searchText:searchBar.rx
            .text
            .orEmpty
            .asDriverOnErrorJustComplete(),
                                                               itemSelected: tableView.rx
            .itemSelected
            .asDriver()))
        output.items.drive(tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! CityCell
            cell.configure(element)
            return cell
        }.disposed(by: bag)
        output.error.drive(onNext: {
            print($0.localizedDescription)
        }).disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
