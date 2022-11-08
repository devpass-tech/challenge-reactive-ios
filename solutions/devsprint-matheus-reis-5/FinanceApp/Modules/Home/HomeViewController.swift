//
//  HomeViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    let service = FinanceService()
    let disposeBag = DisposeBag()
    
    let activitiesObservable = BehaviorRelay<[Activity]>(value: [])

    lazy var homeView: HomeView = {
        let homeView = HomeView()
        homeView.delegate = self
        return homeView
    }()
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfile))
        
        bindObservables()
        
        service.fetchHomeData().subscribe(onNext: { [weak self] (data: HomeData) in
            guard let self = self else { return }
            self.activitiesObservable.accept(data.activity)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    private func bindObservables() {
        activitiesObservable.asObservable()
            .bind(to: homeView.activityListView.tableView.rx.items(cellIdentifier: "ActivityCellIdentifier", cellType: ActivityCellView.self)) { (_, item, cell) in
            cell.setup(with: item)
        }.disposed(by: disposeBag)
        
        homeView.activityListView.tableView.rx.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            
            let item = self.activitiesObservable.value[indexPath.row]
            
            print(item)
        }.disposed(by: disposeBag)
    }

    @objc
    func openProfile() {

        let navigationController = UINavigationController(rootViewController: UserProfileViewController())
        self.present(navigationController, animated: true)
    }
}

extension HomeViewController: HomeViewDelegate {

    func didSelectActivity() {

        let activityDetailsViewController = ActivityDetailsViewController()
        self.navigationController?.pushViewController(activityDetailsViewController, animated: true)
    }
}
