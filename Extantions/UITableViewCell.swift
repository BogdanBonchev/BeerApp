//
//  UITableViewCell.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

extension UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}
