//
//  ContactListViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit

protocol ContactListViewControllerDelegate: AnyObject {
    func selected(contact: Contact)
}

final class ContactListViewController: UIViewController {
    private lazy var service = FinanceService()
    private lazy var viewModel = ContactListViewModel(service: service)

    weak var delegate: ContactListViewControllerDelegate?

    lazy var contactListView: ContactListView = {

        let contactListView = ContactListView()
        contactListView.tableView.delegate = self
        contactListView.tableView.dataSource = self
        return contactListView
    }()

    override func loadView() {
        self.view = contactListView
    }

    override func viewDidLoad() {
        self.title = "Contact List"
        viewModel.fetchContacts()
    }
}

extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCellView.identifier, for: indexPath) as? ContactCellView else {
            return UITableViewCell()
        }
        cell.setupCell(with: viewModel.contacts(at: indexPath))

        return cell
    }
}

extension ContactListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactListView.cellSize
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        delegate?.selected(contact: viewModel.contacts(at: indexPath))
    }
}
