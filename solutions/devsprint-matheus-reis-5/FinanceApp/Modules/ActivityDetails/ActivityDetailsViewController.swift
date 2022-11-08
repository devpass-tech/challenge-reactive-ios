//
//  ActivityDetailsViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxSwift

class ActivityDetailsViewController: UIViewController {

    lazy var activityDetailsView: ActivityDetailsView = {

        let activityDetailsView = ActivityDetailsView()
        return activityDetailsView
    }()
    
    private var itemSelected: Activity
    private var disposeBag = DisposeBag()

    override func loadView() {
        self.view = activityDetailsView
    }
    
    override func viewDidLoad() {
        activityDetailsView.configureUI(data: itemSelected)
        setupRx()
    }
    
    // MARK: - Initializers
    init(_ itemSelected: Activity) {
        self.itemSelected = itemSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
