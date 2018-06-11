//
//  FighterView.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit


class FighterView: GenericView {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var fighterImageView: UIImageView!
    @IBOutlet weak var fighterName: UILabel!
    @IBOutlet weak var fighterLevel: UILabel!
    @IBOutlet weak var fighterHealth: UIProgressView!
    @IBOutlet weak var fighterHealthNumber: UILabel!
    
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
        self.fighterImageView.alpha = 1
        self.itemImageView.image = nil
        self.fighterImageView.image = nil
        self.fighterName.text = "Fighter name"
        self.fighterLevel.text = "0"
        self.fighterHealth.setProgress(0.5, animated: false)
        self.fighterHealthNumber?.text = "0/0"
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        itemImageView.prepareForInterfaceBuilder()
        fighterImageView.prepareForInterfaceBuilder()
        fighterName.prepareForInterfaceBuilder()
        fighterLevel.prepareForInterfaceBuilder()
        fighterHealth.prepareForInterfaceBuilder()
        fighterHealthNumber.prepareForInterfaceBuilder()
    }
    
    func healFighterWith(item: FighterItem){
        Animations.animate(view: self.fighterImageView, animationType: item.animation)
        self.fighter?.currentHealth = min((self.fighter?.maxHealth)!, (self.fighter?.currentHealth)! + item.effectValue)
        updateHealth()
    }
    
    func damageFighterWith(item: FighterItem){
        Animations.animate(view: self.fighterImageView, animationType: item.animation)
        self.fighter?.currentHealth = max(0, (self.fighter?.currentHealth)! - item.effectValue)
        updateHealth()
    }
    
    func damageFighterWith(fightAction: FightAction){
        Animations.animate(view: self.fighterImageView, animationType: fightAction.animation)
        self.fighter?.currentHealth = max(0, (self.fighter?.currentHealth)! - fightAction.damage)
        updateHealth()
    }
    
    func updateHealth() {
        UIView.animate(withDuration: 0.5, animations: {
            self.fighterHealth?.setProgress((self.fighter?.healthForProgressBar())!, animated: true)
            self.fighterHealthNumber?.text = String(format: "%d/%d", (self.fighter?.currentHealth)!,  (self.fighter?.maxHealth)!)
        }) { (finished) in
            if self.fighter?.currentHealth == 0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.fighterImageView.alpha = 0
                }, completion: { (finished) in
                    
                })
            }
        }
    }
    
    func generateViewForFighter(fighter: Fighter){
        self.fighter = fighter
        self.fighterImageView?.image = self.fighter?.image
        self.fighterName?.text = self.fighter?.name!
        self.fighterLevel?.text = String(format: "%d",(self.fighter?.level)!)
        updateHealth()
    }
    
}
