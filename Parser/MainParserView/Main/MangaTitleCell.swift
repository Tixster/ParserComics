//
//  TableViewCell.swift
//  Parser
//
//  Created by Кирилл Тила on 26.09.2021.
//

import UIKit
import SnapKit
import Kingfisher

class MangaTitleCell: UITableViewCell {
    
    static let reuseID = "TableViewCell"
    
    private let bgImageView = UIView()
    
    private var cover: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var title: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lable.textColor = .black
        lable.numberOfLines = 0
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private var author: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = .darkGray
        lable.numberOfLines = 2
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private var descriptionTitle: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lable.textColor = .black
        lable.numberOfLines = 0
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(mangaModel: TitleModel) {
        DispatchQueue.main.async {
            self.title.text = mangaModel.title
            self.author.text = "Автор: \(mangaModel.author)"
            self.descriptionTitle.text = mangaModel.description
            self.cover.kf.indicatorType = .activity
            self.cover.kf.setImage(with: mangaModel.cover)
        }

    }
    
    private func setupUI(){
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(author)
        contentView.addSubview(descriptionTitle)
        
        bgImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.height.equalTo(140)
            make.width.equalTo(100)
        }
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(cover.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(5)
        }
        
        author.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.leading)
            make.trailing.equalTo(title.snp.trailing)
            make.top.equalTo(title.snp.bottom).offset(5)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.leading)
            make.trailing.equalTo(title.snp.trailing)
            make.top.equalTo(author.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(cover.snp.bottom).inset(5)
        }

    }
    
}
