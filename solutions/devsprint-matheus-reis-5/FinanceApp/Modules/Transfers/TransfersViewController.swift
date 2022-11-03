//
//  TransfersViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import RxSwift
import RxCocoa
import UIKit

class TransfersViewController: UIViewController {
    
    let transferAmount = BehaviorRelay<Int>(value: 10)
    let selectedContact = BehaviorRelay<Contact?>(value: nil)
    
    var canTransfer: Observable<Bool> {
        return Observable.combineLatest(transferAmount, selectedContact).map { (amount, contact) in
            return amount > 0 && contact != nil
        }
    }
    
    let disposeBag = DisposeBag()
    
    lazy var transferView: TransfersView = {
        let transferView = TransfersView()
        transferView.delegate = self
        return transferView
    }()
    
    override func loadView() {
        self.view = transferView
    }
    
    override func viewDidLoad() {
        bindObservables()
        bindActions()
    }
    
    private func bindObservables() {
        transferAmount.map { amount in
            return String(format: "$%d", amount)
        }.bind(to: transferView.amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        transferView.amountTextField.rx.text.map { text in
            return Int(text?.replacingOccurrences(of: "$", with: "") ?? "") ?? 0
        }.bind(to: transferAmount).disposed(by: disposeBag)
        
        selectedContact.map { contact in
            return contact == nil ? "Choose contact" : "Change contact"
        }.bind(to: transferView.chooseContactButton.rx.title())
            .disposed(by: disposeBag)
        
        canTransfer
            .bind(to: transferView.transferButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        transferView.transferButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            
            let confirmationViewController = ConfirmationViewController(amount: String(self.transferAmount.value))
            let navigationController = UINavigationController(rootViewController: confirmationViewController)
            self.present(navigationController, animated: true)
        }.disposed(by: disposeBag)
        
        transferView.chooseContactButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            
            let contactListViewController = ContactListViewController()
            contactListViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: contactListViewController)
            self.present(navigationController, animated: true)
        }.disposed(by: disposeBag)
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
    
    func didSelectContact(with contact: Contact) {
        
        selectedContact.accept(contact)
        
        self.dismiss(animated: true)
        
        let alertViewController = UIAlertController(title: "Contact selection", message: "A contact was selected", preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks", style: .default)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true)
    }
}
