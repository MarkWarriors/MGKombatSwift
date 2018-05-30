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
