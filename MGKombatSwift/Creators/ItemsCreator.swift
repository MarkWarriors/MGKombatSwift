//
//  ItemsCreator.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 28/05/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import UIKit

class ItemsCreator : NSObject {
    
    static var shared = ItemsCreator()
    
    public func healtPotion(x: Int) -> FighterItem {
        let item : FighterItem = FighterItem.init()
        item.name = "Healt Potion"
        item.amount = x
        item.effect = .heal
        item.effectValue = 250
        return item
    }
    
    public func tagTeamTommy(x: Int) -> FighterItem {
        let item : FighterItem = FighterItem.init()
        item.name = "HELPMETOMMY"
        item.amount = x
        item.effect = .tagTeamHelp
        item.effectValue = 3
        item.animation = .earthquakeAndFlashing
        item.itemAssociatedFighter = FighterCreator.shared.tommy(isTagTeam: true)
        return item
    }
    
    public func tagTeamMochi(x: Int) -> FighterItem {
        let item : FighterItem = FighterItem.init()
        item.name = "Mochi plz hlap me!"
        item.amount = x
        item.effect = .tagTeamHelp
        item.effectValue = 3
        item.animation = .earthquakeAndFlashing
        item.itemAssociatedFighter = FighterCreator.shared.mochi(isTagTeam: true)
        return item
    }
    
    public func tagTeamMark(x: Int) -> FighterItem {
        let item : FighterItem = FighterItem.init()
        item.name = "MARK PLZ!!"
        item.itemAssociatedFighter = FighterCreator.shared.mark(isTagTeam: true)
        item.amount = x
        item.effect = .tagTeamHelp
        item.effectValue = 3
        item.animation = .earthquakeAndFlashing
        return item
    }
    
    public func tagTeamFrida(x: Int) -> FighterItem {
        let item : FighterItem = FighterItem.init()
        item.name = "FRIDA HLAP!"
        item.amount = x
        item.effect = .tagTeamHelp
        item.effectValue = 3
        item.animation = .earthquakeAndFlashing
        item.itemAssociatedFighter = FighterCreator.shared.frida(isTagTeam: true)
        return item
    }
    
    public func weaponFork(x: Int) -> FighterItem {
        let item : FighterItem = FighterItem.init()
        item.name = "FORK!"
        item.amount = x
        item.image = UIImage.init(named: "forchettone.png")
        item.effect = .damage
        item.effectValue = 150
        item.animation = .flashing
        return item
    }
    
    public func fusionWithTommy(x: Int) -> FighterItem {
        let item : FighterItem = FighterItem.init()
        item.name = "FU SI ON!!!"
        item.amount = x
        item.itemAssociatedFighter = FighterCreator.shared.tonnie(isTagTeam: true)
        item.effect = .fusion
        item.effectValue = 0
        item.animation = .flashing
        return item
    }
    
    
    
}
