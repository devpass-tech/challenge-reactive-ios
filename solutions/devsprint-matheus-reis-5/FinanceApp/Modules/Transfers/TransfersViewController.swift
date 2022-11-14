//
//  TransfersViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxSwift
import RxCocoa

final class TransfersViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = TransfersViewModel()
    
    lazy var transferView: TransfersView = {

        let transferView = TransfersView()
        transferView.delegate = self
        return transferView
    }()

    override func loadView() {
        self.view = transferView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUi()
    }
}

extension TransfersViewController: TransferViewDelegate {

    func didPressChooseContactButton() {

        let contactListViewController = ContactListViewController()
        contactListViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: contactListViewController)
        self.present(navigationController, animated: true)
    }

    func didPressTransferButton(with amount: String) {

        let confirmationViewController = ConfirmationViewController(amount: amount)
        let navigationController = UINavigationController(rootViewController: confirmationViewController)
        self.present(navigationController, animated: true)
    }
}

extension TransfersViewController: ContactListViewControllerDelegate {
    func selected(contact: Contact) {
        didSelectContact(contact)
    }
}

private extension TransfersViewController {
    func bindUi() {
        viewModel.chooseButtonTittle
            .bind(to: transferView.chooseContactButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    func didSelectContact(_ contact: Contact) {
        viewModel.selectedContact(contact)

        self.dismiss(animated: true)

        let alertViewController = UIAlertController(title: "Contact selection", message: "A contact was selected", preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks", style: .default)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true)
    }
}
