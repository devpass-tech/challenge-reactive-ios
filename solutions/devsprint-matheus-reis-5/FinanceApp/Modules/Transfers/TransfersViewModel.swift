//
//  TransfersViewModel.swift
//  FinanceApp
//
//  Created by Gabriela Sillis on 09/11/22.
//

import RxRelay
import RxSwift

protocol TransfersViewModelProtocol {
    var chooseButtonTittle: Observable<String> { get }
    func selectedContact(_ contact: Contact)
}

final class TransfersViewModel {
    private let selectedContact = BehaviorRelay<Contact?>(value: nil)
}

extension TransfersViewModel: TransfersViewModelProtocol {
    var chooseButtonTittle: Observable<String> {
        return selectedContact.map { contact in
            contact?.name ?? "Choose Contact"
        }
    }
    
    func selectedContact(_ contact: Contact) {
        selectedContact.accept(contact)
    }
}
