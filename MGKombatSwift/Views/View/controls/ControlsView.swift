//
//  ControlsView.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class ControlsView: GenericView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mainControlsView: UIView!
    @IBOutlet weak var narrationView: UIView!
    @IBOutlet weak var narrationLbl: UILabel!
    @IBOutlet weak var narrationViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var fightBtn: UIButton!
    @IBOutlet weak var itemBtn: UIButton!
    @IBOutlet weak var optionsBtn: UIButton!
    
    @IBOutlet weak var actionOverlayView: UIView!
    @IBOutlet weak var fightActionCollectionView: UICollectionView!
    @IBOutlet weak var fighterItemsCollectionView: UICollectionView!
    
    @IBOutlet weak var audioController: MGAmznLikeController!
    
    var fightActionCall : ((_ action: FightAction)->())?
    var itemsActionCall : ((_ action: FighterItem)->())?
    
    internal var fighter : Fighter?
    // MARK: LAYOUT INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func commonInit() {
        let customViewNib = loadFromNib()
        customViewNib.frame = bounds
        customViewNib.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(customViewNib)
    }
    
    override func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup(){
        narrationLbl.text = ""
        fightActionCollectionView.register(UINib.init(nibName: FightActionCell.Identifier, bundle: nil), forCellWithReuseIdentifier: FightActionCell.Identifier)
        self.audioController.delegate = MGCNaviagation.shared
        self.audioController.controllerStatus = .play
        self.audioController.setControllerImage(UIImage.init(named: "play_icon.png"), forStatus: .play)
        self.audioController.setControllerImage(UIImage.init(named: "pause_icon.png"), forStatus: .pause)
        resetToInitialViewState()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func generateViewFor(fighter: Fighter){
        self.fighter = fighter
        self.fightActionCollectionView.reloadData()
        self.fighterItemsCollectionView.reloadData()
    }
    
    
    func narrate(text: String){
        self.narrationLbl.text = text
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FightActionCell = fightActionCollectionView.dequeueReusableCell(withReuseIdentifier: FightActionCell.Identifier,
                                                                 for: indexPath) as! FightActionCell
        if collectionView == fightActionCollectionView {
            cell.generateViewFor(fightAction: (self.fighter?.actions[indexPath.row])!)
        }
        else{
            cell.generateViewFor(item: (self.fighter?.items[indexPath.row])!)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fightActionCollectionView {
            return (self.fighter?.actions.count ?? 0)
        }
        else{
            return (self.fighter?.items.count ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        closeActionOverlayTap(self)
        
        if collectionView == fightActionCollectionView {
            let action : FightAction = (self.fighter?.actions[indexPath.row])!
            fightActionCall?(action)
        }
        else{
            let item : FighterItem = (self.fighter?.items[indexPath.row])!
            let amount = ((self.fighter?.items[indexPath.row])?.amount)!
            itemsActionCall?(item)
            if amount > 1 {
                (self.fighter?.items[indexPath.row])?.amount = amount - 1
            }
            else{
                self.fighter?.items.remove(at: indexPath.row)
            }
            fighterItemsCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: Int((self.frame.size.width / 4 * 3)-8), height: FightActionCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 4, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func show(actionView: UICollectionView){
        self.narrate(text: "")
        self.narrationViewTrailing.constant = self.frame.size.width / 4
        self.layoutSubviews()
        actionView.collectionViewLayout.invalidateLayout()
        actionView.collectionViewLayout.prepare()
        actionView.reloadData()
        actionView.isHidden = false
        self.actionOverlayView.isHidden = false
    }
    
    func resetToInitialViewState(){
        self.narrate(text: "")
        self.narrationViewTrailing.constant = 0
        self.actionOverlayView.isHidden = true
        self.fighterItemsCollectionView.isHidden = true
        self.fightActionCollectionView.isHidden = true
    }

    
    @IBAction func closeActionOverlayTap(_ sender: Any) {
        resetToInitialViewState()
    }
        
    @IBAction func fightBtnTap(_ sender: Any) {
        show(actionView: fightActionCollectionView)
    }
    
    @IBAction func itemBtnTap(_ sender: Any) {
        show(actionView: fighterItemsCollectionView)
    }
    
    @IBAction func optionsBtnTap(_ sender: Any) {
        MGCNaviagation.shared.showOptions()
    }
    
    @IBAction func changeSongBtnTap(_ sender: Any) {
        Audios.shared.nextSong()
    }
}
