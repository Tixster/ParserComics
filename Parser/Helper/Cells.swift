//
//  Cells.swift
//  Parser
//
//  Created by Кирилл Тила on 15.05.2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseID: String {
        .init(describing: Self.self)
    }
}

extension UICollectionView {
    static var reuseID: String {
        .init(describing: Self.self)
    }
}
