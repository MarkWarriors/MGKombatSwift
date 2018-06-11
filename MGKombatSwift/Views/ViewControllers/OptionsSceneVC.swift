//
//  OptionsSceneVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 14/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class OptionsSceneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func restartTap(_ sender: Any) {
        self.dismiss(animated: true, completion: { GameInstance.game.resetFighters() })
    }
    
    @IBAction func exitTap(_ sender: Any) {
        GameInstance.game.stop()
        self.dismiss(animated: false, completion: { MGCNaviagation.shared.toSelectPlayer() })
    }
    
    @IBAction func closeTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
