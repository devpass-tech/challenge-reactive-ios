//
//  UITableViewCell+Extensions.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 24/02/22.
//

import Foundation
import UIKit

extension UITableViewCell {

    class func classIdentifier() -> String {
        guard let className = String(describing: self).components(separatedBy: ".").last else {
            return ""
        }

        return className
    }
}
