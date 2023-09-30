//
//  Extension + UITableView.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 24.09.2023.
//

import Foundation
import UIKit

protocol CustomUITableViewDataSource {
    func customDequeueReusableCell(withNameCell name: Cell, for indexPath: IndexPath) -> UITableViewCell
    
}

enum Cell {
    case birthdayTableViewCell
    
    var description: String {
        return String(describing: self)
    }
}

extension UITableView: CustomUITableViewDataSource {
    func customDequeueReusableCell(withNameCell name: Cell, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: name.description, for: indexPath)
        
        return cell
    }
    
}
