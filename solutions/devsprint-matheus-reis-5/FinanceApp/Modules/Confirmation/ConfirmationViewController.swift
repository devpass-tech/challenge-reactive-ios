//
//  ConfirmationViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit

class ConfirmationViewController: UIViewController {

    lazy var confirmationView: ConfirmationView = {

        let confirmationView = ConfirmationView()
        confirmationView.delegate = self
        return confirmationView
    }()

    init(amount: String) {
        super.init(nibName: nil, bundle: nil)

        confirmationView.confirmationLabel.text = "Your transfer of $\(amount) was successful 🤑"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = confirmationView
    }
}

extension ConfirmationViewController: ConfirmationViewDelegate {

    func didPressConfirmationButton() {

        self.dismiss(animated: true)
    }
}
