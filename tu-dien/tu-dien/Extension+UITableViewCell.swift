//
//  Extension+UITableViewCell.swift
//  tu-dien
//
//  Created by BtoW on 1/20/19.
//

import UIKit
import Foundation

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
