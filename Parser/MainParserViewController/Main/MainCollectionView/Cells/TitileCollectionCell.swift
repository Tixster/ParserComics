//
//  TitileCollectionCell.swift
//  Parser
//
//  Created by Кирилл Тила on 30.10.2021.
//

import UIKit
import SDWebImage

class TitileCollectionCell: UICollectionViewCell {
    
    static let resueID = "TitileCollectionCell"
    private let cover: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.sd_imageIndicator = SDWebImageActivityIndicator.gray
        return image
    }()
    private let gradientView = UIView()
    private let gradient = CAGradientLayer()
    
    private let title: UILabel = {
        let label = VerticalAlignLabel()
        label.verticalAlignment = .bottom
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cover.image = nil
        title.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = UIScreen.main.bounds.height * 0.018
        contentView.layer.borderWidth = 2
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.borderColor = UIColor.black.cgColor
        cover.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        gradientView.frame = CGRect(x: 0,
                                    y: Constants.MainCollectionView.itemSize.height / 2,
                                    width: Constants.MainCollectionView.itemSize.width,
                                    height: Constants.MainCollectionView.itemSize.height / 2)
        gradient.frame = gradientView.bounds
        title.frame = CGRect(x: 0, y: 0,
                             width: Constants.MainCollectionView.itemSize.width - 10,
                             height: Constants.MainCollectionView.itemSize.height - 5)
        title.center.x = contentView.center.x
    }
    
    func set(imageURL: URL, title: String) {
        cover.sd_setImage(with: imageURL)
        self.title.text = title
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func setupUI() {
        contentView.addSubview(cover)
        cover.addSubview(gradientView)
        contentView.addSubview(title)

        layer.backgroundColor = UIColor.white.cgColor
    }
    
    private func setupGradient() {
        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.layer.insertSublayer(gradient, at: 0)
    }

}


