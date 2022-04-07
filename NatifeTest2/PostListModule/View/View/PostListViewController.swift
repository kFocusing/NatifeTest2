//
//  PostListViewController.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

class PostListViewController: BaseViewController {
    
    //MARK: - Variables -
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero,
                                style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        return table
    }()
    
    var presenter: PostListPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
        presenter.viewDidLoad()
    }
    
    // MARK: - Internal -
    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func displayError(_ error: String?) {
        guard let error = error else {
            return configureErrorAlert(with: "Error")
        }
        configureErrorAlert(with: error)
    }
    
    //MARK: - Private -
    private func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        layoutTableView()
        PostXibTableViewCell.registerXIB(in: tableView)
    }
    
    private func setupNavigationBar() {
        title = "Post List"
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortPressed)), animated: true)
    }
    
    @objc private func sortPressed() {
        showSortAlert()
    }
    
    private func showSortAlert() {
        let alert = UIAlertController(title: "Choose type of sorting",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Default",
                                      style: .default,
                                      handler: {_ in
            self.presenter.sortPosts(by: .defaultSort)
        }))
        alert.addAction(UIAlertAction(title: "Date",
                                      style: .default,
                                      handler: {_ in
            self.presenter.sortPosts(by: .dateSort)
        }))
        alert.addAction(UIAlertAction(title: "Rating",
                                      style: .default,
                                      handler: { _ in
            self.presenter.sortPosts(by: .ratingSort)
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource -
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostXibTableViewCell.dequeueCell(in: tableView, indexPath: indexPath)
        cell.configure(post: presenter.item(at: indexPath.item)) { [weak self] postID in
            self?.presenter.toglePostIsExpanded(for: postID)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showPostDetail(with: presenter.item(at: indexPath.item)?.postID ?? 0)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PostListViewController: PostListViewProtocol {}
