//
//  ContactListViewModel.swift
//  FinanceApp
//
//  Created by Gabriela Sillis on 08/11/22.
//

import Foundation

protocol ContactListViewModelProtocol {
    var contactsCount: Int { get }
    func contacts(at indexPath: IndexPath) -> Contact
    func fetchContacts()
}

final class ContactListViewModel {
    private let service: FinanceService
    private var contactsList = [Contact]()

    init(service: FinanceService) {
        self.service = service
    }
}
 
extension ContactListViewModel: ContactListViewModelProtocol {
    var contactsCount: Int {
        contactsList.count
    }
    
    func contacts(at indexPath: IndexPath) -> Contact {
        return contactsList[indexPath.row]
    }
    
    func fetchContacts() {
        service.fetchContactList { [weak self] contact in
            switch contact {
            case .some(let contact):
                self?.contactsList = contact
            default:
                break
            }
        }
    }
}
