//
//  WinSceneVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 14/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class WinSceneVC: UIViewController {

    @IBOutlet weak var playerImageView: UIImageView!
    
    public var winnerFighter : Fighter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        self.playerImageView.image = winnerFighter?.image
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1) {
            self.view.alpha = 1
        }
        
        Audios.shared.play(audioType: .win, forceChange: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            GameInstance.game.stop()
            self.dismiss(animated: false, completion: {
                MGCNaviagation.shared.toSelectPlayer()
            })
        })
    }
    


}
