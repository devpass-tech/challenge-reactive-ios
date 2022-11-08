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
}

final class ContactListViewModel {
    private let contactsList: [Contact] = [
        Contact(name: "Gabriela S", phone: "(11) 99888-8888"),
        Contact(name: "Matheus R", phone: "(11) 99888-7777"),
        Contact(name: "Rodrigo B", phone: "(11) 99888-5555")
    ]
    
}
 
extension ContactListViewModel: ContactListViewModelProtocol {
    var contactsCount: Int {
        contactsList.count
    }
    
    func contacts(at indexPath: IndexPath) -> Contact {
        contactsList[indexPath.row]
    }
}
