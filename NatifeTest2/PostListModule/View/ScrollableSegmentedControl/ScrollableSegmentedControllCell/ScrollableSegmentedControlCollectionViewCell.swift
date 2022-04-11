//
//  ScrollableSegmentedControlCollectionViewCell.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 11.04.2022.
//

import UIKit

class SegmentCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Variables -
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        contentView.addSubview(label)
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUIElements()
    }
    
    //MARK: - Internal -
    func configure(textTitle: String,
                   textFont: UIFont = .boldSystemFont(ofSize: 17),
                   textColor: UIColor = .blue,
                   cellBackgroundColor: UIColor = .systemGray4) {
        setupTitle(textЕitle: textTitle,
                   textFont: textFont,
                   textColor: textColor)
        setupCellBackgroundColor(cellBackgroundColor: cellBackgroundColor)
    }
    
    //MARK: - Private -
    private func setupUIElements() {
        layoutContainer()
        layoutLabel()
    }
    private func layoutContainer() {
        containerView.pinEdges(to: self.contentView)
    }
    
    private func layoutLabel() {
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func setupTitle(textЕitle: String,
                            textFont: UIFont,
                            textColor: UIColor) {
        self.title.text = textЕitle.capitalized
        self.title.font = textFont
        self.title.textColor = textColor
    }
    
    private func setupCellBackgroundColor(cellBackgroundColor: UIColor) {
        self.containerView.backgroundColor = cellBackgroundColor
    }
}
