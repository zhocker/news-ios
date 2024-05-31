//
//  NewsTableViewCell.swift
//  news-ios
//
//  Created by User on 31/5/2567 BE.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 3
        return label
    }()
    
    private let authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()

    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(authorImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(articleImageView)

        authorImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.left.equalToSuperview().inset(10)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(authorImageView.snp.right).offset(5)
            make.right.equalTo(articleImageView.snp.left).offset(-10)
        }

        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(authorImageView.snp.right).offset(5)
            make.top.equalTo(authorLabel.snp.bottom).offset(2)
            make.right.equalTo(articleImageView.snp.left).offset(-10)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(articleImageView.snp.left).offset(-10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(articleImageView.snp.left).offset(-10)
            make.bottom.equalToSuperview().inset(10)
        }

        articleImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.top.right.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        articleImageView.snp.remakeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.top.right.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
    }

    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        authorLabel.text = "\(article.author ?? "Unknown") in \(article.source.name)"
        dateLabel.text = article.publishedAt.displayDate()
        if let authorImageUrl = URL(string: "https://example.com/author-image.png") {
            authorImageView.sd_setImage(with: authorImageUrl, placeholderImage: UIImage(systemName: "person.circle"))
        }
        if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
            articleImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
            articleImageView.snp.remakeConstraints { make in
                make.size.equalTo(CGSize(width: 80, height: 80))
                make.top.right.equalToSuperview().inset(10)
                make.bottom.lessThanOrEqualToSuperview().inset(10)
            }
        } else {
            articleImageView.image = nil
            articleImageView.snp.remakeConstraints { make in
                make.size.equalTo(CGSize(width: 0, height: 80))
                make.top.right.equalToSuperview().inset(0)
                make.bottom.lessThanOrEqualToSuperview().inset(0)
            }
        }
    }
    
}