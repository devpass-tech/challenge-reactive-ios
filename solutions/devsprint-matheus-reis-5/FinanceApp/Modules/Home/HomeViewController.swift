//
//  HomeViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class HomeViewController: UIViewController {

    lazy var homeView: HomeView = {
        let homeView = HomeView()
        return homeView
    }()
    
    private var activitiesObervable = BehaviorRelay<[Activity]>(value: [])
    private var service: FinanceService
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(withService service: FinanceService = FinanceService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        configureTableView()
        fetchHomeData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfile))
    }
    
    private func fetchHomeData() {
        service.fetchHomeData().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.activitiesObervable.accept(result.activity)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }

    override func loadView() {
        self.view = homeView
    }

    @objc
    func openProfile() {

        let navigationController = UINavigationController(rootViewController: UserProfileViewController())
        self.present(navigationController, animated: true)
    }
    
    private func configureTableView() {
        activitiesObervable.bind(to: homeView.activityListView.tableView.rx.items(cellIdentifier: "ActivityCellIdentifier", cellType: ActivityCellView.self)) { (row, element, cell) in
            cell.setupUI(with: element)
        }.disposed(by: disposeBag)
        
        
        homeView.activityListView.tableView.rx.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            
            let itemSelected = self.activitiesObervable.value[indexPath.row]
            self.goToDetails(itemSelected)
            
            
        }.disposed(by: disposeBag)
    }
    
    private func goToDetails(_ itemSelected: Activity) {
        let activityDetailsViewController = ActivityDetailsViewController(itemSelected)
        self.navigationController?.pushViewController(activityDetailsViewController, animated: true)
    }
}
