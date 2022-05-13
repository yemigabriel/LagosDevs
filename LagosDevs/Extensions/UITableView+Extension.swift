//
//  UITableView+Extension.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/13/22.
//

import UIKit

extension UITableView {
    func showEmptyMessage(title: String) {
        let label = UILabel()
        label.textAlignment = .center
        label.center = center
        label.text = title
        
        backgroundView = label
    }
    
    func isValidIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0
            && indexPath.section < numberOfSections
            && indexPath.row >= 0
            && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
}

extension UITableView {
}
