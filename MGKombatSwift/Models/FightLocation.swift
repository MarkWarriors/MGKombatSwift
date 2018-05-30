//
//  FightLocation.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class FightLocation : NSObject {
    
    var name : String?
    var sound : String?
    var introAnimation : Animations.AnimationType = .none
    var background : UIImage?
    
    override init() {
        super.init()
    }
}
