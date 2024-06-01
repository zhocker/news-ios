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
import Combine

class NewsDetailViewController: UIViewController {
    
    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alpha = 0
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(typo: .h1)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(typo: .content)
        label.numberOfLines = 0
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(typo: .footer)
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(typo: .footer)
        label.numberOfLines = 0
        return label
    }()

    private let viewModel: NewsDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<NewsDetailViewModel.Input, Never>()

    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        bindViewModel()
        animateScrollView()
        input.send(.viewDidLoad)
    }

    private func setupNavigationBar() {
        title = "News Detail"
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        // Add right button to open in Safari
        let safariButton = UIBarButtonItem(title: "Full Read", style: .plain, target: self, action: #selector(openInSafari))
        safariButton.tintColor = .black
        navigationItem.rightBarButtonItem = safariButton
    }

    @objc private func openInSafari() {
        guard let url = URL(string: viewModel.article.url) else { return }
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
            make.height.equalTo(0) // Initial height set to 0 for later update
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

    private func bindViewModel() {
        let output = viewModel.transform(input: Just(NewsDetailViewModel.Input.viewDidLoad).eraseToAnyPublisher())
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.handleOutput($0) }
            .store(in: &cancellables)
    }

    private func handleOutput(_ output: NewsDetailViewModel.Output) {
        switch output {
        case .displayArticle(imageUrl: let imageUrl, title: let title, desc: let desc, soruce: let source, updateAt: let updateAt):
            populateData(imageUrl: imageUrl, title: title, desc: desc, soruce: source, updateAt: updateAt)
        }
    }

    private func populateData(imageUrl: String, title: String, desc: String, soruce: String, updateAt: String) {
        titleLabel.text = title
        descriptionLabel.text = desc
        authorLabel.text = soruce
        dateLabel.text = updateAt
        if !imageUrl.isEmpty, let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
            setImageViewConstraints(height: 200)
        } else {
            setImageViewConstraints(height: 0)
        }
    }

    private func setImageViewConstraints(height: CGFloat) {
        imageView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

    private func animateScrollView() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        UIView.animate(withDuration: 1.0) {
            self.scrollView.alpha = 1.0
        }
        CATransaction.commit()
    }
    
}
