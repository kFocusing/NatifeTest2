//
//  CellRegister&DequeueReusableExtension.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

//MARK: - TableViewCellDequeueReusable -
protocol TableViewCellDequeueReusable: UITableViewCell { }

//MARK: - TableViewCellRegistable -
protocol TableViewCellRegistable: UITableViewCell { }

//MARK: - CollectionCellDequeueReusable -
protocol CollectionCellDequeueReusable: UICollectionViewCell { }

//MARK: - CollectionCellRegistable -
protocol CollectionCellRegistable: UICollectionViewCell { }


//MARK: - Extensions -
//MARK: - TableViewCellRegistable -
extension TableViewCellRegistable {
    static func register(in tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: String(describing: self))
    }
    
    static func registerXIB(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil),
                           forCellReuseIdentifier: String(describing: self))
    }
}

//MARK: - TableViewCellDequeueReusable -
extension TableViewCellDequeueReusable {
    static func dequeueCell(in tableView: UITableView, indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self),
                                             for: indexPath) as! Self
    }
}

//MARK: - CollectionCellRegistable -
extension CollectionCellRegistable {
    static func register(in collectionView: UICollectionView) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: String(describing: self))
    }
    
    static func registerXIB(in tableView: UICollectionView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil),
                           forCellWithReuseIdentifier: String(describing: self))
    }
}

//MARK: - CollectionCellDequeueReusable -
extension CollectionCellDequeueReusable {
    static func dequeueCellWithType(in collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Self.self),
                                                  for: indexPath) as! Self
    }
}
