//
//  ActivityDetailsViewModel.swift
//  FinanceApp
//
//  Created by Marcelo Simim Santos on 11/10/22.
//

import Foundation
import RxSwift

protocol ActivityDetailsViewModel {
    var activityDetails: PublishSubject<ActivityDetails> { get }

    func fetchActivityDetails()
}

class DefaultActivityDetailsViewModel: ActivityDetailsViewModel {
    private let financeService: FinanceService
    var activityDetails = PublishSubject<ActivityDetails>()

    init(financeService: FinanceService = FinanceService()) {
        self.financeService = financeService
    }

    func fetchActivityDetails() {
        financeService.fetchActivityDetails { [weak self] activityDetails in
            guard let self = self, let activityDetails = activityDetails else { return }
            self.activityDetails.onNext(activityDetails)
        }
    }
}
