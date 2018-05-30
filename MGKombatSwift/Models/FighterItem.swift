//
//  FighterItem.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 14/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class FighterItem : NSObject {
    
    enum ItemEffect : Int {
        case none = -1
        case heal = 0
        case addDamage = 1
        case addResistance = 2
        case doubleTurn = 3
        case damageEnemyHealSelf = 4
        case tagTeamHelp = 5
        case damage = 6
        case fusion = 7
    }
    
    var name : String?
    var amount : Int = 0
    var image : UIImage?
    var effect : ItemEffect = .none
    var effectValue : Int = 0
    var sound : String?
    var animation : Animations.AnimationType = .none
    var user : Fighter?
    var enemy : Fighter?
    var itemAssociatedFighter : Fighter?
    
    override init() {
        super.init()
    }
}
