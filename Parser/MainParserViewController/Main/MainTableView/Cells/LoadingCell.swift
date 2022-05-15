//
//  LoadingCell.swift
//  Parser
//
//  Created by Кирилл Тила on 10.10.2021.
//

import Foundation
import UIKit
import SnapKit

class LoadingCell: UITableViewCell {

    private let bgView = UIView()
    private let indicator = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        indicator.startAnimating()
    }
    
    func stop() {
        indicator.stopAnimating()
    }
    
    private func setupUI() {
        contentView.addSubview(bgView)
        bgView.addSubview(indicator)
        indicator.color = .black
        bgView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        indicator.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalTo(bgView.snp.center)
        }
        
    }
    
}
