//
//  NewsListViewController.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import UIKit
import Combine
import SnapKit
import SDWebImage

public class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel = NewsListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var articles: [Article] = []
    
    private let input = PassthroughSubject<NewsListViewModel.Input, Never>()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search news"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        tableView.rowHeight = 120
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        input.send(.viewDidLoad)
    }

    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main).sink { [weak self] event in
            self?.handleOutput(event)
        }.store(in: &cancellables)
    }

    private func handleOutput(_ output: NewsListViewModel.Output) {
        switch output {
        case .fetchArticlesDidSucceed(let articles):
            self.articles = articles
            self.tableView.reloadData()
        case .fetchArticlesDidFail(let error):
            // Handle error
            showError(error.localizedDescription)
        case .toggleLoading(let isLoading):
            if isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: articles[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let detailVC = NewsDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 4 {
//            input.send(.loadMore)
        }
    }
}

extension NewsListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.search(searchText))
    }
}
