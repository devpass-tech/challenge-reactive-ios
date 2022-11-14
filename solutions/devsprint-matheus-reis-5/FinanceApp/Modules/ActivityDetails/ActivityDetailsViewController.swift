//
//  ActivityDetailsViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import RxCocoa
import RxSwift
import UIKit
import RxSwift

class ActivityDetailsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ActivityDetailsViewModel = DefaultActivityDetailsViewModel()
    private var itemSelected: Activity
    lazy var activityDetailsView: ActivityDetailsView = {

        let activityDetailsView = ActivityDetailsView()
        return activityDetailsView
    }()

    override func loadView() {
        self.view = activityDetailsView
    }
    
    override func viewDidLoad() {
        activityDetailsView.configureUI(data: itemSelected)
        setupRx()
        viewModelBinds()
        viewModel.fetchActivityDetails()
    }
    
    // MARK: - Initializers
    init(_ itemSelected: Activity) {
        self.itemSelected = itemSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func viewModelBinds() {
        viewModel.activityDetails
            .asDriver(onErrorJustReturn: ActivityDetails(name: "Error", price: 0.0, category: "", time: ""))
            .drive { [weak self] activityDetails in
                guard let self = self else { return }
                self.activityDetailsView.configure(activityDetails)
            }.disposed(by: disposeBag)
    }
    
    func setupRx() {
        activityDetailsView
            .reportIssueButton
            .rx
            .tap
            .subscribe( {[ weak self ] _ in
                guard let self = self else { return }
                self.didPressReportButton()
            }).disposed(by: disposeBag)
        
    }
    
    func didPressReportButton() {
        let alertViewController = UIAlertController(title: "Report an issue", message: "The issue was reported", preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks", style: .default)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true)
    }
}
