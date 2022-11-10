//
//  ActivityDetailsViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import RxCocoa
import RxSwift
import UIKit

class ActivityDetailsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ActivityDetailsViewModel = DefaultActivityDetailsViewModel()
    lazy var activityDetailsView: ActivityDetailsView = {

        let activityDetailsView = ActivityDetailsView()
        activityDetailsView.delegate = self
        return activityDetailsView
    }()

    override func loadView() {
        self.view = activityDetailsView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModelBinds()
        viewModel.fetchActivityDetails()
    }

    private func viewModelBinds() {
        viewModel.activityDetails.bind { [weak self] activityDetails in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityDetailsView.configure(activityDetails)
            }
        }.disposed(by: disposeBag)
    }
}

extension ActivityDetailsViewController: ActivityDetailsViewDelegate {

    func didPressReportButton() {

        let alertViewController = UIAlertController(title: "Report an issue", message: "The issue was reported", preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks", style: .default)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true)
    }
}
