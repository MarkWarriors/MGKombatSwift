//
//  MGCollectionView.swift
//  MGCollectionView
//
//  Created by Marco Guerrieri on 11/03/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

@objc class MGCellForRows : NSObject {
    var iPhonePortrait = 0
    var iPhoneLandscape = 0
    var iPadPortrait = 0
    var iPadLandscape = 0
    
    public static let zero = MGCellForRows.init(iPhonePortrait: 0, iPhoneLandscape: 0, iPadPortrait: 0, iPadLandscape: 0)
    
    init(iPhonePortrait: Int, iPhoneLandscape: Int, iPadPortrait: Int, iPadLandscape: Int) {
        super.init()
        self.iPhonePortrait = iPhonePortrait
        self.iPhoneLandscape = iPhoneLandscape
        self.iPadPortrait = iPadPortrait
        self.iPadLandscape = iPadLandscape
    }
}

@objc protocol MGCollectionViewProtocol {
    @objc func collectionViewDisplayItem(_ item: Any, inCell cell: UICollectionViewCell) -> UICollectionViewCell
    @objc func collectionViewRequestDataForPage(page: Int, valuesCallback: @escaping ([Any]?)->())
    @objc optional func collectionViewSelected(cell: UICollectionViewCell, withItem item: Any)
    @objc optional func collectionViewDeselected(cell: UICollectionViewCell, withItem item: Any)
    @objc optional func collectionViewPullToRefreshControlStatusIs(animating: Bool)
    @objc optional func collectionViewEndUpdating(totalElements: Int)
}


public enum IdiomAndOrientationEnum {
    case iPhonePortrait
    case iPhoneLandscape
    case iPadPortrait
    case iPadLandscape
}
public typealias IdiomAndOrientation = IdiomAndOrientationEnum

public enum CellLayoutTypeEnum {
    case fixedWidthAndHeight
    case fixedNumberForRow
}
public typealias CellLayoutType = CellLayoutTypeEnum

@IBDesignable class MGCollectionView : UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBInspectable var pullToRefresh : Bool = false
    @IBInspectable var useInfiniteScroll : Bool = false
    @IBInspectable var useLoaderAtBottom : Bool = true
    @IBInspectable var autoDeselectItem : Bool = true
    
    var cellNib : UINib? = nil
    var cellIdentifier : String? = nil
    var cellClass : AnyClass? = nil
    
    public var items : [Any] = []
    
    private var cellProportions : CGSize = CGSize.zero
    private var cellSpacing : UIEdgeInsets = UIEdgeInsets.zero
    private var cellLayoutType : CellLayoutType?
    private var cellsWidth : CGFloat = 0
    private var cellsHeight : CGFloat = 0
    private var cellsForRow : MGCellForRows = MGCellForRows.zero
    private var currentPage : Int = 0
    private var isLoading : Bool = false
    private var endInifiniteScroll = false
    private var footerHeight : CGFloat = 0.0
    private var footerWidth : CGFloat = 0.0
    private var flowLayout : UICollectionViewFlowLayout?
    private var triggeredHorizontalPullToRefresh : Bool = false
    private var horizontalPtR : UIActivityIndicatorView?
    private var horizontalPtRSize : CGFloat = 30
    private var horizontalPtRTriggerinOffset : CGFloat = -70.0
    private var horizontalPtrYConstraint : NSLayoutConstraint?
    private var scrollViewIsMovingToHorizontalPtrTriggeringOffset = false
    private var currentOrientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    private var lastOffsetX : CGFloat = 0
    public private(set)var cvRefreshControl : UIRefreshControl = UIRefreshControl()
    
    var protocolDelegate : MGCollectionViewProtocol? = nil
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func initWithCellFixed(size: CGSize, andMinimumSpacingBetweenCells spacing: UIEdgeInsets) {
        cellLayoutType = .fixedWidthAndHeight
        self.cellsWidth = size.width
        self.cellsHeight = size.height
        self.cellSpacing = spacing
        self.cellProportions = size
        initCollectionView()
    }
    
    func initWithCellFixedNumberOfCellsForRow(_ cellsForRow: MGCellForRows, cellProportions: CGSize, andSpacing spacing: UIEdgeInsets) {
        self.cellLayoutType = .fixedNumberForRow
        self.cellsForRow = cellsForRow
        self.cellProportions = cellProportions
        self.cellSpacing = spacing
        initCollectionView()
    }
    
    private func initCollectionView() {
        self.delegate = self
        self.dataSource = self
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout = layout
        }
        else {
            assertionFailure("#MGCollectionView: Needed flow layout for the MGCollectionView")
        }
        
        if cellLayoutType == nil {
            print("#MGCollectionView: No layout type provided")
            return
        }
        
        if cellLayoutType == .fixedWidthAndHeight {
            if cellsWidth == 0 {
                assertionFailure("#MGCollectionView: The cell width is 0.")
            }
            if cellsWidth > self.frame.size.width {
                print("#MGCollectionView: The cell width is greater then the Collection view. Change it to the width of the Collection View.")
            }
        }
        
        if self.cellProportions.width == 0 || self.cellProportions.height == 0 {
            assertionFailure("#MGCollectionView: cell proportion with a dimension equal to 0.")
        }
        
        if cellIdentifier == nil {
            assertionFailure("#MGCollectionView: cellIdentifier required")
        }
        
        if cellNib != nil {
            self.register(cellNib, forCellWithReuseIdentifier: cellIdentifier!)
        }
        else if cellClass != nil {
            self.register(cellClass, forCellWithReuseIdentifier: cellIdentifier!)
        }
        
        if pullToRefresh {
            if flowLayout?.scrollDirection == .horizontal {
                horizontalPtR = UIActivityIndicatorView.init()
                horizontalPtR!.isHidden = false
                horizontalPtR!.alpha = 0
                horizontalPtR!.translatesAutoresizingMaskIntoConstraints = false
                horizontalPtR!.color = UIColor.black
                horizontalPtR!.hidesWhenStopped = false
                self.insertSubview(self.horizontalPtR!, at: 0)
                addConstraint(NSLayoutConstraint.init(item: horizontalPtR!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
                horizontalPtrYConstraint = NSLayoutConstraint.init(item: horizontalPtR!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
                addConstraint(horizontalPtrYConstraint!)
            }
            else {
                cvRefreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
                self.addSubview(cvRefreshControl)
            }
        }
        
        if useLoaderAtBottom {
            self.register(MGCollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willChangeOrientation), name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeOrientation), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        
        askItemsForPage(0)
    }
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        }
    }
    
    
    @objc func willChangeOrientation() {
        lastOffsetX = contentOffset.x
    }
    
    
    @objc func didChangeOrientation() {
        currentOrientation = UIApplication.shared.statusBarOrientation
    }
    
    
    
    @objc
    private func refreshTriggered() {
        endInifiniteScroll = false
        isLoading = true
        items.removeAll()
        if protocolDelegate?.collectionViewPullToRefreshControlStatusIs != nil {
            protocolDelegate?.collectionViewPullToRefreshControlStatusIs!(animating: true)
        }
        askItemsForPage(0)
    }
    
    func clearItems() {
        self.currentPage = 0
        self.items.removeAll()
        reloadCollectionView()
    }
    
    func addItems(_ newItems: [Any]) {
        self.items.append(contentsOf: newItems)
        reloadCollectionView()
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.reloadData()
            self.performBatchUpdates({
            }, completion: { (completed) in
                self.endLoadingData()
            })
        }
    }
    
    func endLoadingData() {
        self.isLoading = false
        if pullToRefresh {
            if flowLayout?.scrollDirection == .vertical && self.cvRefreshControl.isRefreshing {
                self.cvRefreshControl.endRefreshing()
                if self.protocolDelegate?.collectionViewPullToRefreshControlStatusIs != nil {
                    self.protocolDelegate?.collectionViewPullToRefreshControlStatusIs!(animating: false)
                }
                if self.protocolDelegate?.collectionViewEndUpdating != nil {
                    self.protocolDelegate?.collectionViewEndUpdating!(totalElements: self.items.count)
                }
            }
            
            if flowLayout?.scrollDirection == .horizontal && self.triggeredHorizontalPullToRefresh {
                triggeredHorizontalPullToRefresh = false
                horizontalPtR?.alpha = 0
                horizontalPtR?.stopAnimating()
                if self.contentOffset.x < 0 {
                    self.setContentOffset(CGPoint.init(x: 0, y: self.contentOffset.y), animated: true)
                }
                if protocolDelegate?.collectionViewPullToRefreshControlStatusIs != nil {
                    protocolDelegate?.collectionViewPullToRefreshControlStatusIs!(animating: false)
                }
            }
        }
        
        self.checkIfNeedMoreItems()
    }
    
    
    func askItemsForPage(_ page: Int) {
        currentPage = page
        if currentPage == 0 {
            self.items.removeAll()
        }
        protocolDelegate?.collectionViewRequestDataForPage(page: currentPage, valuesCallback: { (newValues) in
            if newValues != nil && newValues!.count > 0 {
                self.addItems(newValues!)
            }
            else {
                self.endInifiniteScroll = true
                DispatchQueue.main.async {
                    // remove footer
                    self.collectionViewLayout.invalidateLayout()
                }
                self.endLoadingData()
            }
        })
    }
    
    private func checkIfNeedMoreItems() {
        if self.useInfiniteScroll {
            if flowLayout?.scrollDirection == .horizontal {
                if contentSize.width < frame.size.width && !triggeredHorizontalPullToRefresh {
                    self.askItemsForPage(currentPage + 1)
                }
            }
            else {
                if contentSize.height < frame.size.height {
                    self.askItemsForPage(currentPage + 1)
                }
            }
        }
    }
    
    func deviceOrientationAndIdiom() -> IdiomAndOrientationEnum {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if  currentOrientation.isPortrait {
                return .iPadPortrait
            }
            else {
                return .iPadLandscape
            }
        }
        else {
            if currentOrientation.isPortrait {
                return .iPhonePortrait
            }
            else {
                return .iPhoneLandscape
            }
        }
    }
    
    func pickCorrectCellsForRow() -> Int {
        switch(deviceOrientationAndIdiom()) {
            case .iPhonePortrait:
                return cellsForRow.iPhonePortrait
            case .iPhoneLandscape:
                return cellsForRow.iPhoneLandscape
            case .iPadPortrait:
                return cellsForRow.iPadLandscape
            case .iPadLandscape:
                return cellsForRow.iPadPortrait
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if triggeredHorizontalPullToRefresh {
            if scrollView.contentOffset.x < horizontalPtRTriggerinOffset {
                self.setContentOffset(CGPoint.init(x: horizontalPtRTriggerinOffset, y: scrollView.contentOffset.y), animated: true)
            }
            else {
                self.setContentOffset(CGPoint.init(x: 0, y: scrollView.contentOffset.y), animated: true)
            }
        }
    }
    
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let offsetY = scrollView.contentOffset.y
        if flowLayout?.scrollDirection == .horizontal && pullToRefresh {
            // Horizontal pull to refresh
            if triggeredHorizontalPullToRefresh && !scrollView.isDragging {
                if offsetX < horizontalPtRTriggerinOffset && !scrollViewIsMovingToHorizontalPtrTriggeringOffset {
                    scrollViewIsMovingToHorizontalPtrTriggeringOffset = true
                    self.setContentOffset(CGPoint.init(x: horizontalPtRTriggerinOffset, y: offsetY), animated: true)
                }
                if scrollViewIsMovingToHorizontalPtrTriggeringOffset && floor(offsetX) == horizontalPtRTriggerinOffset {
                    self.setContentOffset(contentOffset, animated: false)
                    scrollViewIsMovingToHorizontalPtrTriggeringOffset = false
                }
            }
            else if !triggeredHorizontalPullToRefresh && pullToRefresh && !isLoading {
                if offsetX < horizontalPtRTriggerinOffset {
                    triggeredHorizontalPullToRefresh = true
                    horizontalPtR?.startAnimating()
                    horizontalPtR?.alpha = 1
                    refreshTriggered()
                }
            }
            
            if offsetX < 0{
                if !triggeredHorizontalPullToRefresh {
                    horizontalPtR?.alpha = (offsetX + 10) / horizontalPtRTriggerinOffset
                    let degrees = (offsetX + 10) * 365 / horizontalPtRTriggerinOffset * CGFloat(Double.pi)/180
                    horizontalPtR?.transform = CGAffineTransform(rotationAngle: degrees)
                }
                horizontalPtrYConstraint?.constant = offsetX + 10
            }
        }
        
        if useInfiniteScroll && !isLoading && self.items.count > 0 && !endInifiniteScroll {
            var actualPosition : CGFloat = 0
            var contentReferenceSize : CGFloat = 0
            if flowLayout?.scrollDirection == .horizontal {
                actualPosition = offsetX + frame.size.width
                contentReferenceSize = contentSize.width - (50)
            }
            else {
                actualPosition = offsetY + frame.size.height
                contentReferenceSize = contentSize.height - (50)
            }
            if actualPosition >= contentReferenceSize {
                isLoading = true
                self.askItemsForPage(currentPage + 1)
            }
        }
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier!, for: indexPath)
        if items.count > indexPath.row  && protocolDelegate != nil {
            let item = items[indexPath.row]
            return (protocolDelegate?.collectionViewDisplayItem(item, inCell: cell))!
        }
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if autoDeselectItem {
            self.deselectItem(at: indexPath, animated: true)
        }
        if items.count > indexPath.row {
            let item = items[indexPath.row]
            protocolDelegate?.collectionViewSelected?(cell: cellForItem(at: indexPath)!, withItem: item)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if items.count > indexPath.row {
            let item = items[indexPath.row]
            protocolDelegate?.collectionViewDeselected?(cell: cellForItem(at: indexPath)!, withItem: item)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat = 0
        var height : CGFloat = 0
        if cellLayoutType == .fixedWidthAndHeight {
            if cellsWidth > self.frame.size.width{
                cellsWidth = self.frame.size.width
            }
            width = cellsWidth
            height = cellsHeight
        }
        else if cellLayoutType == .fixedNumberForRow {
            let cfr : Int = pickCorrectCellsForRow()
            width = (self.frame.size.width / CGFloat(cfr)) - CGFloat(cellSpacing.left + cellSpacing.right)
            height = CGFloat(width * cellProportions.height / cellProportions.width) - CGFloat(cellSpacing.top + cellSpacing.bottom)
        }
        return CGSize.init(width: width, height: height)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(cellSpacing.top, cellSpacing.left, cellSpacing.bottom, cellSpacing.right)
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if useInfiniteScroll && !endInifiniteScroll && useLoaderAtBottom{
            if flowLayout?.scrollDirection == .horizontal {
                footerWidth = 70
                footerHeight = self.bounds.size.height
            }
            else {
                footerWidth = self.bounds.size.width
                footerHeight = 70
            }
        }
        else {
            footerHeight = 0
            footerWidth = 0
        }
        return CGSize.init(width: footerWidth, height: footerHeight)
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter && useLoaderAtBottom {
            return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! MGCollectionViewFooter
        }
        return UICollectionReusableView.init(frame: CGRect.zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if flowLayout?.scrollDirection == .horizontal && triggeredHorizontalPullToRefresh && contentOffset.y <= 0 {
            setContentOffset(CGPoint.init(x: lastOffsetX, y: proposedContentOffset.y), animated: true)
            return CGPoint.init(x: lastOffsetX, y: proposedContentOffset.y)
        }
        return proposedContentOffset
    }
    
}

class MGCollectionViewFooter : UICollectionReusableView {
    let ref = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: 35))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        ref.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ref)
        addConstraint(NSLayoutConstraint.init(item: ref, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: ref, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        ref.center = self.center
        ref.startAnimating()
        ref.isHidden = false
        ref.hidesWhenStopped = false
        ref.color = UIColor.black
        self.bringSubview(toFront: ref)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

