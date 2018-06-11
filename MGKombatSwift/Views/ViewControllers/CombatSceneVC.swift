//
//  CombatSceneVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class CombatSceneVC: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var opponentView: OpponentView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controlsView: ControlsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameInstance.game.combatScene = self
        initializeControls()
        GameInstance.game.start()
    }
    
    func initializeControls(){
        self.controlsView.optionsCall = {
            self.performSegue(withIdentifier: Segues.options, sender: self)
        }
        
        self.controlsView.fightActionCall = { action in
            GameInstance.game.fight(action: action, byFighter: GameInstance.game.player!)
        }
        
        self.controlsView.itemsActionCall = { item in
            GameInstance.game.used(item: item, byFighter: GameInstance.game.player!)
        }
        
        self.opponentView.fightActionCall = { action in
            GameInstance.game.fight(action: action, byFighter: GameInstance.game.opponent!)
        }
        
        self.opponentView.itemsActionCall = { item in
            GameInstance.game.used(item: item, byFighter: GameInstance.game.opponent!)
        }
    }

}
