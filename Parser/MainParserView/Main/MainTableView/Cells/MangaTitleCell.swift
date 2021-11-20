//
//  TableViewCell.swift
//  Parser
//
//  Created by Кирилл Тила on 26.09.2021.
//

import UIKit
import SDWebImage

class MangaTitleCell: UITableViewCell {
    
    static let reuseID = "MangaTitleCell"
    
    private let bgImageView = UIView()
    private let bgDescriptionView = UIView()
    
    private var cover: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.sd_imageIndicator = SDWebImageActivityIndicator.gray
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
    
    private var descriptionTitle: UITextView = {
        let lable = UITextView()
        lable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lable.textColor = .black
        lable.textAlignment = .left
        lable.textContainerInset = .zero
        lable.textContainer.lineFragmentPadding = .zero
        lable.isEditable = false
        lable.showsVerticalScrollIndicator = false
        lable.linkTextAttributes = [.foregroundColor: UIColor.blue,
                                    .underlineStyle: NSUnderlineStyle.single.rawValue]
        return lable
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = Constants.MainTableView.heightTableViewMangaCell * 0.08
        contentView.layer.masksToBounds = true
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: UIScreen.main.bounds.height * 0.015, left: UIScreen.main.bounds.width * 0.026, bottom: 0, right: UIScreen.main.bounds.width * 0.026))
        bgImageView.layer.shadowColor = UIColor.black.cgColor
        bgImageView.layer.shadowOpacity = 1
        bgImageView.layer.shadowOffset = CGSize.zero
        bgImageView.layer.shadowPath = UIBezierPath(rect: bgImageView.bounds).cgPath
        bgImageView.layer.shadowRadius = 2
        bgImageView.layer.masksToBounds = false
        cover.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.isOpaque = true
        setupFrameUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        self.selectionStyle = .none
        separatorInset = .zero
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cover.image = nil
        title.text = nil
        author.text = nil
        descriptionTitle.text = nil
    }
    
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setupFrameUI()
    }

    func configure(mangaModel: TitleModel) {
        self.title.text = mangaModel.title
        self.author.text = "Автор: \(mangaModel.author)"
        self.descriptionTitle.text = mangaModel.description
        cover.sd_setImage(with: mangaModel.cover)
    }
    
    private func setupFrameUI() {
        
        bgImageView.frame = CGRect(x: 0, y: 0,
                                   width: Constants.MainTableView.widthCoverTableCell,
                                   height: Constants.MainTableView.heightTableViewMangaCell)
        cover.frame = CGRect(x: 0, y: 0,
                             width: Constants.MainTableView.widthCoverTableCell,
                             height: Constants.MainTableView.heightTableViewMangaCell)
        title.frame = CGRect(x: bgImageView.frame.width +
                                Constants.MainTableView.widthCoverTableCell * 0.08,
                             y: contentView.bounds.minY +
                                Constants.MainTableView.heightTableViewMangaCell * 0.03,
                             width: contentView.bounds.width - title.frame.minX -
                                Constants.MainTableView.widthCoverTableCell * 0.08,
                             height: title.font.lineHeight)
        title.sizeToFit()
        
        author.frame = CGRect(x: title.frame.minX,
                              y: title.frame.maxY + 5,
                              width: contentView.bounds.width - title.frame.minX - 8,
                              height: author.font.lineHeight)
        author.sizeToFit()
        
        
        bgDescriptionView.frame = CGRect(x: author.frame.minX,
                                         y: author.frame.maxY + Constants.MainTableView.widthCoverTableCell * 0.05,
                                         width: contentView.bounds.width - title.frame.minX - Constants.MainTableView.widthTableViewMangaCell * 0.08,
                                         height: contentView.bounds.height - bgDescriptionView.frame.minY - Constants.MainTableView.widthCoverTableCell * 0.05)
        bgDescriptionView.clipsToBounds = true
        
        descriptionTitle.frame = CGRect(x: 0,
                                        y: 0,
                                        width: bgDescriptionView.bounds.width,
                                        height: bgDescriptionView.bounds.height)
        
    }
    
    private func setupUI(){
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(author)
        contentView.addSubview(bgDescriptionView)
        bgDescriptionView.addSubview(descriptionTitle)
    }
    
}
