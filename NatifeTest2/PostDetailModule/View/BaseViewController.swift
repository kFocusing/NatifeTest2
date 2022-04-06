//
//  BaseViewController.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 06.04.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - Variables -
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutActivityIndicator()
    }
    
    //MARK: -Internal
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    //MARK: - Private -
    private func layoutActivityIndicator() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

