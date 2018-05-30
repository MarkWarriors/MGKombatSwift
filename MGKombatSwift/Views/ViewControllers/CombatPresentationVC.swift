//
//  CombatPresentationVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class CombatPresentationVC: UIViewController {
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var playerViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var opponentView: UIView!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentNameLbl: UILabel!
    @IBOutlet weak var opponentViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var vsLbl: UILabel!
    @IBOutlet weak var inLbl: UILabel!
    @IBOutlet weak var locationNameLbl: UILabel!
    
    var start : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start = false
        self.playerView.isHidden = true
        self.opponentView.isHidden = true
        
        if GameInstance.game.player == nil {
            GameInstance.game.player = FighterCreator.shared.connie()
        }
        
        if GameInstance.game.opponent == nil {
            GameInstance.game.opponent = FighterCreator.shared.mark()
        }
        
        if GameInstance.game.location == nil {
            GameInstance.game.location = LocationsCreator.shared.montalto()
        }
        
        self.playerImageView.image = (GameInstance.game.player?.image)!
        self.playerNameLbl.text = (GameInstance.game.player?.name)!
        self.opponentImageView.image = (GameInstance.game.opponent?.image)!
        self.opponentNameLbl.text = (GameInstance.game.opponent?.name)!
        self.locationNameLbl.text = (GameInstance.game.location?.name)!
        
        Audios.shared.play(audioType: .presentation, forceChange: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vsLbl.alpha = 0
        self.inLbl.alpha = 0
        locationNameLbl.alpha = 0
        opponentViewLeading.constant = 0 - self.view.frame.size.width
        playerViewTrailing.constant = 0 - self.view.frame.size.width
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playerView.isHidden = false
        self.opponentView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.startAnimation()
        })
    }
    
    func startAnimation(){
        self.playerViewTrailing.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.opponentViewLeading.constant = 0
            if completion {
                UIView.animate(withDuration: 1, animations: {
                    self.vsLbl.alpha = 1
                })
                
                UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }) { (completion) in
                    
                    UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                        self.inLbl.alpha = 1
                        self.locationNameLbl.alpha = 1
                    }) { (completion) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.startFight()
                        })
                    }
                }
            }
        }
        
    }

    @objc func startFight(){
        if !start{
            start = true
            self.performSegue(withIdentifier: Segues.combat, sender: self)
        }
    }


}
