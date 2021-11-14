//
//  TitileCollectionCell.swift
//  Parser
//
//  Created by Кирилл Тила on 30.10.2021.
//

import UIKit
import Kingfisher

class TitileCollectionCell: UICollectionViewCell {
    
    static let resueID = "TitileCollectionCell"
    private let cover: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        gradient.frame = gradientView.bounds
    }
    
    func set(imageURL: URL, title: String) {
        self.cover.kf.indicatorType = .activity
        self.cover.kf.setImage(with: imageURL)
        self.title.text = title
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func setupUI() {
        contentView.addSubview(cover)
        cover.addSubview(gradientView)
        contentView.addSubview(title)
        cover.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        gradientView.frame = CGRect(x: 0,
                                    y: contentView.bounds.height / 2,
                                    width: contentView.bounds.width,
                                    height: contentView.bounds.height / 2)
        title.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width - 10, height: contentView.bounds.height - 5)
 
        title.center.x = contentView.center.x
    }
    
    private func setupGradient() {
        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
}


