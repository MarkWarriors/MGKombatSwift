//
//  Fighter.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class Fighter : NSObject {
    
    var id : Int?
    var name : String?
    var image : UIImage?
    var maxHealth : Int = 1
    var currentHealth : Int = 1
    var level : Int = 1
    var sound : String?
    var isStunned :  Bool = false
    var isPoisoned :  Bool = false
    var actions : [FightAction] = []
    var items : [FighterItem] = []
    var perks : [FighterPerk] = []
    var playinFighter : Bool = false
    var animation : Animations.AnimationType = .none
    var deadAnimation : Animations.AnimationType = .none
    var winAnimation : Animations.AnimationType = .none
    var initialAnimation : Animations.AnimationType = .none
    
    override init() {
        super.init()
    }
 
    func copy(with zone: NSZone? = nil) -> Fighter{
        let fighter = Fighter()
        fighter.id = self.id
        fighter.name = self.name
        fighter.image = self.image
        fighter.maxHealth = self.maxHealth
        fighter.currentHealth = self.currentHealth
        fighter.level = self.level
        fighter.sound = self.sound
        fighter.isStunned = self.isStunned
        fighter.actions = self.actions
        fighter.items.append(contentsOf: self.items)
        fighter.perks = self.perks
        fighter.playinFighter = self.playinFighter
        fighter.animation = self.animation
        fighter.deadAnimation = self.deadAnimation
        fighter.winAnimation = self.winAnimation
        fighter.initialAnimation = self.initialAnimation
        return fighter
    }
    
    
    func randomAttack() -> FightAction {
        let randomChoice = Int(arc4random_uniform(UInt32((self.actions.count)-1)))
        return self.actions[randomChoice]
    }
    
    func randomItem() -> FighterItem {
        let randomChoice = Int(arc4random_uniform(UInt32((self.items.count)-1)))
        return self.items[randomChoice]
    }
    
    func healthForProgressBar() -> Float{
        return Float(self.currentHealth) / Float(self.maxHealth)
    }
    
    func reset(){
        self.currentHealth = self.maxHealth 
    }
}
