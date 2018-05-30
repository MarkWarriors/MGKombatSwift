//
//  OpponentView.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class OpponentView: FighterView {

    var fightActionCall : ((_ action: FightAction)->())?
    var itemsActionCall : ((_ action: FighterItem)->())?
    
    func artificialInteligenceFightTurn(){
        let randomAttack = self.fighter?.randomAttack()
        self.fightActionCall?(randomAttack!)
    }
    
}
