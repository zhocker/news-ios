//
//  NewsDetailViewController.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import UIKit
import SDWebImage
import SnapKit
import SafariServices

class NewsDetailViewController: UIViewController {
    
    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private let article: Article

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        populateData()
    }

    private func setupNavigationBar() {
        title = "News Detail"
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        // add right button goto safari
        let safariButton = UIBarButtonItem(title: "Full Read", style: .plain, target: self, action: #selector(openInSafari))
        safariButton.tintColor = .black
        navigationItem.rightBarButtonItem = safariButton
    }

    @objc private func openInSafari() {
        guard let url = URL(string: article.url) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView).offset(-16)
        }

    }

    private func populateData() {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        authorLabel.text = "Source: \(article.author ?? "Unknown") in \(article.source.name)"
        dateLabel.text = article.publishedAt.displayDate()

        if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
            imageView.snp.remakeConstraints { make in
                make.top.equalTo(contentView).offset(16)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(200)
            }
        } else {
            imageView.snp.remakeConstraints { make in
                make.top.equalTo(contentView).offset(16)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(0)
            }
        }
    }

}
