//
//  PostListViewController.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

class PostListViewController: UIViewController {
    
    //MARK: - Variables -
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero,
                                style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        return table
    }()
    
    var presenter: PostListPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupNavigationBar()
    }
    
    
    // MARK: - Internal -
    func setupTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.layoutTableView()
            PostXibTableViewCell.registerXIB(in: self!.tableView)
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - Private -
    private func layoutTableView() {
        tableView.pinEdges(to: self.view, topSpace: -35)
    }
    
    private func setupNavigationBar() {
        title = "Post List"
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortPressed)), animated: true)
    }
    
    @objc private func sortPressed() {
        self.present(configureSortAlert(), animated: true, completion: nil)
    }
    
    private func configureSortAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Choose type of sorting",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Default",
                                      style: .default,
                                      handler: {_ in
            self.presenter.posts = self.presenter.posts.sorted(by: { $0.postID < $1.postID })
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Date",
                                      style: .default,
                                      handler: {_ in
            self.presenter.posts = self.presenter.posts.sorted(by: { $0.timeshamp > $1.timeshamp })
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Rating",
                                      style: .default,
                                      handler: { _ in
            self.presenter.posts = self.presenter.posts.sorted(by: { $0.likesCount > $1.likesCount })
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        return alert
    }
}

//MARK: - UITableViewDataSource -
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostXibTableViewCell.dequeueCell(in: tableView, indexPath: indexPath)
        cell.configure(post: presenter.item(at: indexPath.item))
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tapPostDetail(postID: presenter.item(at: indexPath.item).postID)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PostListViewController: PostListViewProtocol { }

//MARK: - //MARK: - Private - -
extension PostListViewController: UpdateCellSizeDelegate {
    func readMoreTapped() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateIsExpended(withID id: Int) {
        guard let postIndex = presenter.posts.firstIndex(where: { post in post.postID == id }) else { return }
        presenter.posts[postIndex].isExpended.toggle()
    }
}
