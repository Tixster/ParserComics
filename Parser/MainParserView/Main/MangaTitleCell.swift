//
//  TableViewCell.swift
//  Parser
//
//  Created by Кирилл Тила on 26.09.2021.
//

import UIKit
import Kingfisher

class MangaTitleCell: UITableViewCell {
    
    static let reuseID = "TableViewCell"
    
    private let bgImageView = UIView()

    private var cover: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private var title: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lable.textColor = .black
        lable.numberOfLines = 3
        return lable
    }()
    
    private var author: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = .darkGray
        lable.numberOfLines = 2
        return lable
    }()
    
    private var descriptionTitle: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lable.textColor = .black
        lable.lineBreakMode = .byTruncatingTail
        lable.numberOfLines = 0
        return lable
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        bgImageView.layer.shadowColor = UIColor.black.cgColor
        bgImageView.layer.shadowOpacity = 1
        bgImageView.layer.shadowOffset = CGSize.zero
        bgImageView.layer.shadowRadius = 2
        bgImageView.layer.masksToBounds = false
        cover.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        setupFrameUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cover.image = nil
    }
    
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setupFrameUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(mangaModel: TitleModel) {
            self.title.text = mangaModel.title
            self.author.text = "Автор: \(mangaModel.author)"
            self.descriptionTitle.text = mangaModel.description
            self.cover.kf.indicatorType = .activity
            self.cover.kf.setImage(with: mangaModel.cover)
    }
    
    private func setupFrameUI() {
    
        bgImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 140)
        cover.frame = CGRect(x: 0, y: 0, width: 100, height: 140)
        title.frame = CGRect(x: bgImageView.frame.maxX + 8,
                             y: contentView.bounds.minY + 5,
                             width: contentView.bounds.width - title.frame.minX - 8,
                             height: title.font.lineHeight)
        title.sizeToFit()
        
        author.frame = CGRect(x: title.frame.minX,
                              y: title.frame.maxY + 5,
                              width: contentView.bounds.width - title.frame.minX - 8,
                              height: author.font.lineHeight)
        author.sizeToFit()
        
        
        descriptionTitle.frame = CGRect(x: author.frame.minX,
                                        y: author.frame.maxY + 5,
                                        width: contentView.bounds.width - title.frame.minX - 8,
                                        height: contentView.bounds.height - descriptionTitle.frame.minY - 5)
        let descriptionTitleSize: CGRect = descriptionTitle.frame
        descriptionTitle.sizeToFit()
        if descriptionTitle.frame.height > descriptionTitleSize.height {
            descriptionTitle.frame = descriptionTitleSize
        }
        
    }
    
    private func setupUI(){
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(author)
        contentView.addSubview(descriptionTitle)

    }
    
}
