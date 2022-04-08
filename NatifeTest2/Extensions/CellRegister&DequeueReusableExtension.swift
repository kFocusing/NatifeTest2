//
//  CellRegister&DequeueReusableExtension.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

//MARK: - CellDequeueReusable -
protocol CellDequeueReusable: UITableViewCell { }

//MARK: - CellRegistable -
protocol CellRegistable: UITableViewCell { }

//MARK: - Extensions -
//MARK: - CellRegistable -
extension CellRegistable {
    static func register(in tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: String(describing: self))
    }
    
    static func registerXIB(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil),
                           forCellReuseIdentifier: String(describing: self))
    }
}

//MARK: - CellDequeueReusable -
extension CellDequeueReusable {
    static func dequeueCell(in tableView: UITableView, indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self),
                                             for: indexPath) as! Self
    }
}
