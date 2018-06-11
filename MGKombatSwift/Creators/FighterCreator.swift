//
//  FighterCreator.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 14/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class FighterCreator : NSObject {
    
    static var shared = FighterCreator()
    
    public func getAllFighters() -> [Fighter]{
        var fighters : [Fighter] = []
        
        fighters.append(connie())
        fighters.append(mark())
        fighters.append(giuky())
        fighters.append(tommy())
        fighters.append(frida())
        fighters.append(mochi())
        
        return fighters
    }
    
    
    public func connie(isTagTeam: Bool = false) -> Fighter {
        var fighterActions : [FightAction] = []
        let action1 : FightAction = FightAction.init()
        action1.name = "Rageee"
        action1.damage = 110
        action1.animation = Animations.AnimationType.earthquakeAndFlashing
        let action2 : FightAction = FightAction.init()
        action2.name = "Bite!"
        action2.damage = 60
        action2.animation = Animations.AnimationType.flashing
        let action3 : FightAction = FightAction.init()
        action3.name = "High kick!"
        action3.damage = 80
        action3.animation = Animations.AnimationType.rotation
        let action4 : FightAction = FightAction.init()
        action4.name = "Thunder scream"
        action4.damage = 70
        action4.animation = Animations.AnimationType.earthquake
        fighterActions.append(action1)
        fighterActions.append(action2)
        fighterActions.append(action3)
        fighterActions.append(action4)
        
        let fighter : Fighter = Fighter.init()
        fighter.id = 2
        fighter.name = "Connie"
        fighter.image = UIImage.init(named: "connie.png")
        fighter.maxHealth = 500
        fighter.currentHealth = fighter.maxHealth
        fighter.level = 30
        fighter.sound = nil
        fighter.actions = fighterActions
        fighter.perks = []
        fighter.playinFighter = true
        
        if !isTagTeam{
            fighter.items.append(ItemsCreator.shared.healtPotion(x: 4))
            fighter.items.append(ItemsCreator.shared.tagTeamFrida(x: 1))
            fighter.items.append(ItemsCreator.shared.tagTeamTommy(x: 1))
            fighter.items.append(ItemsCreator.shared.fusionWithTommy(x: 1))
        }
        
        return fighter
    }
    
    public func mark(isTagTeam: Bool = false) -> Fighter {
        var fighterActions : [FightAction] = []
        let action1 : FightAction = FightAction.init()
        action1.name = "Ugly dancing"
        action1.damage = 90
        action1.animation = Animations.AnimationType.earthquakeAndFlashing
        let action2 : FightAction = FightAction.init()
        action2.name = "Sing without rythm"
        action2.damage = 70
        action2.animation = Animations.AnimationType.flashing
        let action3 : FightAction = FightAction.init()
        action3.name = "Developer rage"
        action3.damage = 110
        action3.animation = Animations.AnimationType.earthquake
        let action4 : FightAction = FightAction.init()
        action4.name = "Onion breath"
        action4.damage = 35
        action4.animation = Animations.AnimationType.rotation
        fighterActions.append(action1)
        fighterActions.append(action2)
        fighterActions.append(action3)
        fighterActions.append(action4)
        
        let fighter : Fighter = Fighter.init()
        fighter.id = 1
        fighter.name = "Mark"
        fighter.image = UIImage.init(named: "maruko.png")
        fighter.maxHealth = 450
        fighter.currentHealth = fighter.maxHealth
        fighter.level = 25
        fighter.sound = nil
        fighter.actions = fighterActions
        fighter.perks = []
        fighter.playinFighter = true
        
        if !isTagTeam{
            fighter.items.append(ItemsCreator.shared.healtPotion(x: 5))
            fighter.items.append(ItemsCreator.shared.tagTeamMochi(x: 1))
            fighter.items.append(ItemsCreator.shared.weaponFork(x: 2))
        }
        
        return fighter
    }
    
    public func giuky(isTagTeam: Bool = false) -> Fighter {
        var fighterActions : [FightAction] = []
        let action1 : FightAction = FightAction.init()
        action1.name = "Scratchinggg"
        action1.damage = 80
        action1.animation = Animations.AnimationType.flashing
        let action2 : FightAction = FightAction.init()
        action2.name = "Bitingggg"
        action2.damage = 100
        action2.animation = Animations.AnimationType.flashing
        let action3 : FightAction = FightAction.init()
        action3.name = "Sushi thrower"
        action3.damage = 50
        action3.animation = Animations.AnimationType.earthquake
        let action4 : FightAction = FightAction.init()
        action4.name = "Exploding kitten"
        action4.damage = 90
        action4.animation = Animations.AnimationType.earthquakeAndFlashing
        fighterActions.append(action1)
        fighterActions.append(action2)
        fighterActions.append(action3)
        fighterActions.append(action4)
        
        
        
        let fighter : Fighter = Fighter.init()
        fighter.id = 3
        fighter.name = "Giuky"
        fighter.image = UIImage.init(named: "giuky.png")
        fighter.maxHealth = 450
        fighter.currentHealth = fighter.maxHealth
        fighter.level = 33
        fighter.sound = nil
        fighter.actions = fighterActions
        fighter.perks = []
        fighter.playinFighter = true
        
        if !isTagTeam{
            fighter.items.append(ItemsCreator.shared.healtPotion(x: 6))
            fighter.items.append(ItemsCreator.shared.tagTeamMark(x: 2))
            fighter.items.append(ItemsCreator.shared.weaponFork(x: 1))
        }
        
        
        return fighter
    }
    
    
    public func mochi(isTagTeam: Bool = false) -> Fighter {
        var fighterActions : [FightAction] = []
        let action1 : FightAction = FightAction.init()
        action1.name = "Kawaii cuteness"
        action1.damage = 50
        action1.animation = Animations.AnimationType.bigEarthquake
        let action2 : FightAction = FightAction.init()
        action2.name = "Wow"
        action2.damage = 70
        action2.animation = Animations.AnimationType.earthquake
        let action3 : FightAction = FightAction.init()
        action3.name = "Such Cute"
        action3.damage = 90
        action3.animation = Animations.AnimationType.flashing
        let action4 : FightAction = FightAction.init()
        action4.name = "Much Doge"
        action4.damage = 80
        action4.animation = Animations.AnimationType.earthquakeAndFlashing
        fighterActions.append(action1)
        fighterActions.append(action2)
        fighterActions.append(action3)
        fighterActions.append(action4)
        
        let fighter : Fighter = Fighter.init()
        fighter.id = 30
        fighter.name = "Mochi"
        fighter.image = UIImage.init(named: "mochi.png")
        fighter.maxHealth = 500
        fighter.currentHealth = fighter.maxHealth
        fighter.level = 42
        fighter.sound = nil
        fighter.actions = fighterActions
        fighter.perks = []
        fighter.playinFighter = false
        
        if !isTagTeam{
            fighter.items.append(ItemsCreator.shared.healtPotion(x: 6))
            fighter.items.append(ItemsCreator.shared.tagTeamMark(x: 2))
            fighter.items.append(ItemsCreator.shared.weaponFork(x: 1))
        }
        return fighter
    }
    
    public func tommy(isTagTeam: Bool = false) -> Fighter {
        var fighterActions : [FightAction] = []
        let action1 : FightAction = FightAction.init()
        action1.name = "Razor blade nail"
        action1.damage = 80
        action1.animation = Animations.AnimationType.flashing
        let action2 : FightAction = FightAction.init()
        action2.name = "MEEeeEeEeEEEEowwWWWW"
        action2.damage = 30
        action2.animation = Animations.AnimationType.earthquake
        let action3 : FightAction = FightAction.init()
        action3.name = "Shiny Deadly Glance"
        action3.damage = 20
        action3.animation = Animations.AnimationType.flashing
        let action4 : FightAction = FightAction.init()
        action4.name = "Overpowered tail hit"
        action4.damage = 120
        action4.animation = Animations.AnimationType.bigEarthquake
        fighterActions.append(action1)
        fighterActions.append(action2)
        fighterActions.append(action3)
        fighterActions.append(action4)
        
        let fighter : Fighter = Fighter.init()
        fighter.id = 22
        fighter.name = "Tommaso"
        fighter.image = UIImage.init(named: "tommaso.png")
        fighter.maxHealth = 900
        fighter.currentHealth = fighter.maxHealth
        fighter.level = 42
        fighter.sound = nil
        fighter.actions = fighterActions
        fighter.perks = []
        fighter.playinFighter = false
        
        if !isTagTeam{
            fighter.items.append(ItemsCreator.shared.healtPotion(x: 3))
            fighter.items.append(ItemsCreator.shared.fusionWithTommy(x: 2))
            fighter.items.append(ItemsCreator.shared.weaponFork(x: 3))
        }
        return fighter
    }
    
    public func frida(isTagTeam: Bool = false) -> Fighter {
        var fighterActions : [FightAction] = []
        let action1 : FightAction = FightAction.init()
        action1.name = "Boresome Whistle"
        action1.damage = 120
        action1.animation = Animations.AnimationType.bigEarthquake
        let action2 : FightAction = FightAction.init()
        action2.name = "Muzzle smash"
        action2.damage = 50
        action2.animation = Animations.AnimationType.earthquake
        let action3 : FightAction = FightAction.init()
        action3.name = "Huge Lick"
        action3.damage = 40
        action3.animation = Animations.AnimationType.flashing
        let action4 : FightAction = FightAction.init()
        action4.name = "Clumsy hug"
        action4.damage = 30
        action4.animation = Animations.AnimationType.flashing
        fighterActions.append(action1)
        fighterActions.append(action2)
        fighterActions.append(action3)
        fighterActions.append(action4)
        
        let fighter : Fighter = Fighter.init()
        fighter.id = 23
        fighter.name = "Frida"
        fighter.image = UIImage.init(named: "frida.png")
        fighter.maxHealth = 400
        fighter.currentHealth = fighter.maxHealth
        fighter.level = 42
        fighter.sound = nil
        fighter.actions = fighterActions
        fighter.perks = []
        fighter.playinFighter = false
        
        if !isTagTeam{
            fighter.items.append(ItemsCreator.shared.healtPotion(x: 4))
            fighter.items.append(ItemsCreator.shared.tagTeamMochi(x: 3))
            fighter.items.append(ItemsCreator.shared.weaponFork(x: 1))
        }
        return fighter
    }
    
    
    public func tonnie(isTagTeam: Bool = false) -> Fighter{
        var fighterActions : [FightAction] = []
        let action1 : FightAction = FightAction.init()
        action1.name = "ThunderRage"
        action1.damage = 140
        action1.animation = Animations.AnimationType.earthquakeAndFlashing
        let action2 : FightAction = FightAction.init()
        action2.name = "Evil nails of death"
        action2.damage = 120
        action2.animation = Animations.AnimationType.flashing
        let action3 : FightAction = FightAction.init()
        action3.name = "Meow2"
        action3.damage = 80
        action3.animation = Animations.AnimationType.rotation
        let action4 : FightAction = FightAction.init()
        action4.name = "Killer Cuddles"
        action4.damage = 80
        action4.animation = Animations.AnimationType.earthquake
        fighterActions.append(action1)
        fighterActions.append(action2)
        fighterActions.append(action3)
        fighterActions.append(action4)
        
        
        let fighter : Fighter = Fighter.init()
        fighter.id = 1001
        fighter.name = "Tonnie"
        fighter.image = UIImage.init(named: "tonnie.png")
        fighter.maxHealth = 900
        fighter.currentHealth = fighter.maxHealth
        fighter.level = 99
        fighter.sound = nil
        fighter.actions = fighterActions
        fighter.items = []
        fighter.perks = []
        fighter.playinFighter = true
        
        return fighter
    }
}

