//
//  FightAction.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation

class FightAction : NSObject {
    
    var name : String?
    var damage : Int = 0
    var sound : String?
    var animation : Animations.AnimationType = .none
 
    override init() {
        super.init()
    }
}
