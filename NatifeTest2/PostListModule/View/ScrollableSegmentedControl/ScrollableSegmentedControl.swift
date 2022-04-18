//
//  ScrollableSegmentedControl.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 11.04.2022.
//

import UIKit

class DynamicSegmentedControl: UIView {
    
    //MARK: - UIElements -
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = collectionViewBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        return collectionView
    }()
    
    private var selectionIndicator = UIView()
    
    //MARK: - Private Properties -
    private var segmentedItems: [String] = []
    
    private let textFont: UIFont = .boldSystemFont(ofSize: 17)
    private let textColor: UIColor = .black
    
    private let underlineColor: UIColor = .black
    private let underlineMovementSpeed: TimeInterval = 0.25
    
    private let cellBackgroundColor: UIColor = .white
    private let collectionViewBackgroundColor: UIColor = .white
    
    private let minimumInteritemSpacing: CGFloat = 60
    private let cellTextIndent: CGFloat = 20
    private let itemHeight: CGFloat = 50
    
    private lazy var itemsPerRow: CGFloat = {
        var itemsPerRow = CGFloat(segmentedItems.count)
        return itemsPerRow
    }()
    
    private var isDrawed: Bool = false
    
    private var changeSelectedItem: ((ListDisplayMode) -> Void)?
    
    //MARK: - Life Cycle -
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initSubviews()
    }
    
    required init(changeSelectedItem: ((ListDisplayMode) -> Void)?,
                  segmentedItems: [String],
                  textFont: UIFont = .boldSystemFont(ofSize: 17),
                  textColor: UIColor = .blue,
                  underlineColor: UIColor = .blue,
                  underlineMovementSpeed: TimeInterval = 0.4,
                  cellBackgroundColor: UIColor = .systemGray4,
                  collectionViewBackgroundColor: UIColor = .systemGray4,
                  minimumInteritemSpacing: CGFloat = 1,
                  cellTextIndent: CGFloat = 20,
                  itemHeight: CGFloat = 50) {
        super.init(frame: .zero)
        self.changeSelectedItem = changeSelectedItem
        self.segmentedItems = segmentedItems
        initSubviews()
    }
    
    required init(changeSelectedItem: ((ListDisplayMode) -> Void)?,
                  textFont: UIFont = .boldSystemFont(ofSize: 17),
                  textColor: UIColor = .blue,
                  underlineColor: UIColor = .blue,
                  underlineMovementSpeed: TimeInterval = 0.4,
                  cellBackgroundColor: UIColor = .systemGray4,
                  collectionViewBackgroundColor: UIColor = .systemGray4,
                  minimumInteritemSpacing: CGFloat = 1,
                  cellTextIndent: CGFloat = 20,
                  itemHeight: CGFloat = 50) {
        super.init(frame: .zero)
        self.changeSelectedItem = changeSelectedItem
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isDrawed == false {
            setupSegment()
            isDrawed.toggle()
        }
    }
    
    //MARK: - Internal -
    func configure(with segments: [String]) {
        segmentedItems = segments
        collectionView.reloadData()
    }
    
    //MARK: - Private -
    private func initSubviews() {
        setupCollectionView()
    }
    
    private func setupSegment() {
        let segmentUnderlineWidth: CGFloat = (getSegmentWidth(from: segmentedItems[0]) * itemsPerRow) + cellTextIndent * 2
        let segmentUnderlineHeight: CGFloat = 2.0
        let segmentUnderLineYPosition = collectionView.bounds.maxY - 1
        
        var segmentUnderlineFrame = CGRect()
        segmentUnderlineFrame.size = CGSize(width: segmentUnderlineWidth, height: segmentUnderlineHeight)
        
        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
        segmentUnderline.center = CGPoint(x: segmentUnderlineWidth / 2 + minimumInteritemSpacing,
                                          y: segmentUnderLineYPosition)
        segmentUnderline.backgroundColor = UIColor.clear
        
        addUnderlineForSelectedSegment()
        collectionView.addSubview(segmentUnderline)
    }
    
    private func addUnderlineForSelectedSegment() {
        let underlineWidth: CGFloat = getSegmentWidth(from: segmentedItems[0]) + cellTextIndent
        let underlineHeight: CGFloat = 2.0
        let underLineYPosition = collectionView.bounds.maxY - 1
        
        var underlineFrame = CGRect()
        underlineFrame.size = CGSize(width: underlineWidth, height: underlineHeight)
        
        selectionIndicator = UIView(frame: underlineFrame)
        selectionIndicator.center = CGPoint(x: underlineWidth / 2 + minimumInteritemSpacing,
                                            y: underLineYPosition)
        selectionIndicator.backgroundColor = underlineColor
        collectionView.addSubview(selectionIndicator)
    }
    
    func changeUnderlinePosition(indexPath: IndexPath) {
        guard let choosenItem = collectionView.layoutAttributesForItem(at:indexPath) else { return }
        UIView.animate(withDuration: underlineMovementSpeed) { [self] in
            let xPointCoordinate = choosenItem.center.x
            let width = choosenItem.frame.width
            selectionIndicator.frame.size.width = width
            selectionIndicator.center.x = xPointCoordinate
        }
    }
    
    private func setupCollectionView() {
        layoutCollectionView()
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        SegmentCollectionViewCell.register(in: collectionView)
    }
    
    private func layoutCollectionView() {
        collectionView.pinEdges(to: self)
    }
    
    private func getSegmentWidth(from segment: String) -> CGFloat {
        return segment.size(withAttributes: [NSAttributedString.Key.font: textFont]).width
    }
}


// MARK: - Extensions -
// MARK: - UICollectionViewDataSource -
extension DynamicSegmentedControl: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return segmentedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SegmentCollectionViewCell.dequeueCellWithType(in: collectionView,
                                                                 indexPath: indexPath)
        let title = segmentedItems[indexPath.item]
        cell.configure(textTitle: title,
                       textFont: textFont,
                       textColor: textColor,
                       cellBackgroundColor: cellBackgroundColor)
        return cell
    }
}

// MARK: - UICollectionViewDelegate -
extension DynamicSegmentedControl: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        changeUnderlinePosition(indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
        changeSelectedItem?(ListDisplayMode(rawValue: indexPath.item) ?? .list)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DynamicSegmentedControl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getSegmentWidth(from: segmentedItems[indexPath.item].capitalized) + cellTextIndent, height: itemHeight)
    }
}
