//
//  PostListViewController.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

class PostListViewController: BaseViewController {
    
    //MARK: - UIElements -
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero,
                                style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        table.isHidden = false
        return table
    }()
    
    private lazy var dynamicSegmentedControl: DynamicSegmentedControl = {
        let dynamicSegmentedControl = DynamicSegmentedControl(changeSelectedItem: updateSelectedViewType)
        let segmentArray = ["List", "Grid", "Gallery"]
        dynamicSegmentedControl.configure(with: segmentArray)
        dynamicSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dynamicSegmentedControl)
        return dynamicSegmentedControl
    }()
    
    private var collectionView: UICollectionView!
    
    //MARK: - Variables -
    var presenter: PostListPresenterProtocol!
    private var itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private var galleryCollectionViewChoosen = true
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupCollectionView()
        layoutDynamicSegmentedControl()
        layoutDynamicSegmentedControl()
        presenter.viewDidLoad()
    }
    
    //MARK: - Private -
    private func layoutDynamicSegmentedControl() {
        NSLayoutConstraint.activate([
            dynamicSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dynamicSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dynamicSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dynamicSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                            constant: 45)
        ])
    }
    
    private func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        layoutTableView()
        PostXibTableViewCell.registerXIB(in: tableView)
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: calculateWidthforItem(),
                                                  height: 140)
        layout.sectionInset = sectionInsets
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        layoutCollectionView()
        GalleryPreviewPostCollectionViewCell.registerXIB(in: collectionView)
        collectionView.isHidden = true
    }
    
    private func layoutCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    private func calculateWidthforItem() -> CGFloat {
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return widthPerItem
    }
    
    private func updateSelectedViewType(_ selectedIndex: Int) {
        if selectedIndex == ModuleType.list.rawValue {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else if selectedIndex == ModuleType.grid.rawValue  {
            itemsPerRow = 2
            galleryCollectionViewChoosen = false
            tableView.isHidden = true
            collectionView.isHidden = false
            GridPreviewPostCollectionViewCell.registerXIB(in: collectionView)
            collectionView.reloadData()
        } else {
            itemsPerRow = 1
            galleryCollectionViewChoosen = true
            tableView.isHidden = true
            collectionView.isHidden = false
            GalleryPreviewPostCollectionViewCell.registerXIB(in: collectionView)
            collectionView.reloadData()
        }
    }
}

//MARK: - TableViewExtensions -
//MARK: - UITableViewDataSource -
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostXibTableViewCell.dequeueCell(in: tableView, indexPath: indexPath)
        let item = presenter.item(at: indexPath.row)
        cell.configure(post: item) { [weak self] in
            self?.presenter.toglePostIsExpanded(for: indexPath.row)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        presenter.showPostDetail(with: presenter.item(at: indexPath.row)?.postID ?? 0)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - CollectionViewExtensions -
//MARK: - UICollectionViewDelegate -
extension PostListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: calculateWidthforItem(), height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.showPostDetail(with: presenter.item(at: indexPath.row)?.postID ?? 0)
    }
}


//MARK: - UICollectionViewDataSource -
extension PostListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if galleryCollectionViewChoosen {
            let cell = GalleryPreviewPostCollectionViewCell.dequeueCellWithType(in: collectionView,
                                                                                indexPath: indexPath)
            let item = presenter.item(at: indexPath.item)
            cell.configure(post: item) { [weak self] in
                self?.presenter.toglePostIsExpanded(for: indexPath.item)
            }
            cell.addBorder()
            return cell
        } else {
            let cell = GridPreviewPostCollectionViewCell.dequeueCellWithType(in: collectionView,
                                                                             indexPath: indexPath)
            
            let item = presenter.item(at: indexPath.item)
            cell.configure(post: item)
            cell.addBorder()
            return cell
        }
    }
}

// MARK: - PostListViewProtocol -
extension PostListViewController: PostListViewProtocol {
    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
    }
    
    func displayError(_ error: String) {
        configureErrorAlert(with: error)
    }
}

private enum ModuleType: Int, CaseIterable {
    case list = 0, grid, gallery
}
