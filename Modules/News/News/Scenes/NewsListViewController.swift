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
import Core

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
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: String(describing: NewsTableViewCell.self))
        tableView.rowHeight = 120
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .blue
        return indicator
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        input.send(.viewDidLoad)
    }

    private func setupViews() {
        
        self.title = "News"
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(searchBar)

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = refreshControl

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

    @objc private func didPullToRefresh() {
        input.send(.viewDidLoad)
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
            self.refreshControl.endRefreshing()
        case .fetchArticlesDidFail(let error):
            // Handle error
            showError(error.localizedDescription)
            self.refreshControl.endRefreshing()
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
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self), for: indexPath) as? NewsTableViewCell,
            let article = self.articles.takeSafe(index: indexPath.row)
        else {
            return UITableViewCell()
        }
        cell.configure(with: article)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.articles.count - 1 {
            input.send(.loadMore)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = self.articles.takeSafe(index: indexPath.row) else { return }
        self.routeToNewsDetail(article: article)
    }

//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        if offsetY > contentHeight - scrollView.frame.height * 4 {
////            input.send(.loadMore)
//        }
//    }
}

extension NewsListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.search(searchText))
    }
}

extension NewsListViewController {
    
    func routeToNewsDetail(article: Article) {
        let vc = NewsDetailViewController(viewModel: NewsDetailViewModel(article: article))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
