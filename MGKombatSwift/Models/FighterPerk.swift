//
//  FighterPerk.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation

class FighterPerk : NSObject {
    
    var name : String?
    var effect : String?
    var sound : String?
    var animation : Animations.AnimationType = .none
    
    override init() {
        super.init()
    }
}
