//
//  GameInstance.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

final class GameInstance {
    
    private init() { }
    
    static let game = GameInstance()
    
    var player : Fighter?
    var opponent : Fighter?
    var location : FightLocation?
    var combatScene : CombatSceneVC?
    var playerOriginalStatus : Fighter?
    var opponentOriginalStatus : Fighter?
    
    var additionalPlayerTurn = 0
    var additionalOpponentTurn = 0
    
    func start() {
        playerOriginalStatus = player?.copy(with: nil)
        opponentOriginalStatus = opponent?.copy(with: nil)
        self.combatScene?.playerView.generateViewForFighter(fighter: player!)
        self.combatScene?.opponentView.generateViewForFighter(fighter: opponent!)
        self.combatScene?.controlsView.generateViewFor(fighter: player!)
        self.combatScene?.backgroundImageView.image = location?.background
        
        Audios.shared.play(audioType: .battle, forceChange: true)
    }
    
    func stop() {
        GameInstance.game.player = nil
        GameInstance.game.opponent = nil
        GameInstance.game.location = nil
        GameInstance.game.combatScene = nil
    }
 
    func restart() {
        player = GameInstance.game.playerOriginalStatus
        opponent = GameInstance.game.opponentOriginalStatus
        additionalPlayerTurn = 0
        additionalOpponentTurn = 0
        start()
    }
    
    func resetFighters() {
        player = playerOriginalStatus?.copy(with: nil)
        opponent = opponentOriginalStatus?.copy(with: nil)
        restart()
    }
    
    
    func startPlayerTurn() {
        if self.gameContinue() {
            self.combatScene?.controlsView.narrate(text: "It's \(self.player?.name ?? " turn")")
            self.combatScene?.controlsView.isUserInteractionEnabled = true
        }
    }
    
    func startOpponentTurn() {
        if self.gameContinue() {
            self.combatScene?.controlsView.narrate(text: "It's  \(self.opponent?.name ?? " turn")")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.combatScene?.opponentView.artificialInteligenceFightTurn()
            })
        }
    }
    
    func playerEndTurn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                self.combatScene?.playerView.itemImageView.alpha = 0
            })
            self.startOpponentTurn()
        })
    }
    
    func opponentEndTurn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                self.combatScene?.opponentView.itemImageView.alpha = 0
            })
            self.startPlayerTurn()
        })
    }
    
    func gameContinue() -> Bool {
        if self.player?.currentHealth == 0 {
            self.combatScene?.playerView.fighterImageView.alpha = 0
            self.combatScene?.performSegue(withIdentifier: Segues.defeat, sender: self)
            return false
        }
        if self.opponent?.currentHealth == 0{
            self.combatScene?.opponentView.fighterImageView.alpha = 0
            self.combatScene?.performSegue(withIdentifier: Segues.win, sender: self)
            return false
        }
        return true
    }

    
    func fight(action: FightAction, byFighter: Fighter){
        self.combatScene?.controlsView.narrate(text: "\(byFighter.name ?? "") attack with \(action.name ?? "")!!")
        
        if byFighter == player {
            self.combatScene?.controlsView.isUserInteractionEnabled = false
            self.combatScene?.opponentView.damageFighterWith(fightAction: action)
            
            if self.additionalPlayerTurn > 0 {
                self.additionalPlayerTurn = self.additionalPlayerTurn - 1
                self.startPlayerTurn()
            }
            else{
                self.playerEndTurn()
            }
        }
        else{
            self.combatScene?.playerView.damageFighterWith(fightAction: action)
            
            if self.additionalOpponentTurn > 0 {
                self.additionalOpponentTurn = self.additionalOpponentTurn - 1
                self.startOpponentTurn()
            }
            else{
                self.opponentEndTurn()
            }
        }
    }
    
    
    
    func used(item: FighterItem, byFighter: Fighter){
        let endItem : (()->()) = {
            if self.gameContinue() {
                if byFighter == self.player {
                    self.playerEndTurn()
                }
                else{
                    self.opponentEndTurn()
                }
            }
        }
        
        self.combatScene?.controlsView.isUserInteractionEnabled = false
        switch item.effect {
        case .heal:
            self.combatScene?.playerView.healFighterWith(item: item)
            self.combatScene?.controlsView.narrate(text: "\(byFighter.name ?? "") use \(item.name ?? "") for healing himself!")
            endItem()
            break
        case .damage:
            self.combatScene?.playerView.itemImageView.alpha = 0
            if item.image != nil {
                self.combatScene?.playerView.itemImageView.image = item.image
           
                UIView.animate(withDuration: 0.5, animations: {
                    self.combatScene?.playerView.itemImageView.alpha = 1
                })
            }
            self.combatScene?.controlsView.narrate(text: "\(byFighter.name ?? "") use \(item.name ?? "") per pestare il nemico!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.combatScene?.opponentView.damageFighterWith(item: item)
                endItem()
            })
            break
        case .addDamage:
            self.combatScene?.controlsView.narrate(text: "\(byFighter.name ?? "") use \(item.name ?? ""), diventa più forte!")
            endItem()
            break
        case .addResistance:
            self.combatScene?.controlsView.narrate(text: "\(byFighter.name ?? "") use \(item.name ?? ""), diventa più resistente!")
            endItem()
            break
        case .doubleTurn:
            self.combatScene?.controlsView.narrate(text: "\(byFighter.name ?? "") use \(item.name ?? "") e raddoppia il suo turno!")
            self.additionalPlayerTurn = 1
            endItem()
            break
        case .damageEnemyHealSelf:
            self.combatScene?.controlsView.narrate(text: "\(byFighter.name ?? "") use \(item.name ?? ""), si cura e danneggia l'avversario!")
            self.combatScene?.playerView.healFighterWith(item: item)
            self.combatScene?.opponentView.damageFighterWith(item: item)
            endItem()
            break
        case .fusion:
            self.combatScene?.controlsView.narrate(text: "FU SIO NEHHH")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.combatScene?.playerView.itemImageView.alpha = 0
                self.combatScene?.controlsView.narrate(text: "ECCO \(item.itemAssociatedFighter?.name?.uppercased() ?? "")!!")
                item.itemAssociatedFighter?.items = (GameInstance.game.player?.items)!
                GameInstance.game.player = item.itemAssociatedFighter
                self.combatScene?.playerView.generateViewForFighter(fighter: GameInstance.game.player!)
                self.combatScene?.controlsView.generateViewFor(fighter: GameInstance.game.player!)
                UIView.animate(withDuration: 0.5, animations: {
                    self.combatScene?.playerView.itemImageView.alpha = 1
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    endItem()
                })
            })
            break
        case .tagTeamHelp:
            self.combatScene?.controlsView.narrate(text: "Arriva \(item.itemAssociatedFighter?.name?.uppercased() ?? "???") in aiuto!!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.combatScene?.controlsView.narrate(text: "Eccolohhh!!!")
                self.combatScene?.playerView.itemImageView.alpha = 0
                self.combatScene?.playerView.itemImageView.image = item.itemAssociatedFighter?.image
                UIView.animate(withDuration: 0.5, animations: {
                    self.combatScene?.playerView.itemImageView.alpha = 1
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let action = item.itemAssociatedFighter?.randomAttack()
                    self.combatScene?.controlsView.narrate(text: "\(item.itemAssociatedFighter?.name?.uppercased() ?? "???") attacca \(item.effectValue) \(item.effectValue == 1 ? "volta" : "volte" ) con \(action?.name ?? "")!")
                    action?.damage = (action?.damage)! * item.effectValue
                    self.combatScene?.opponentView.damageFighterWith(fightAction: action!)
                    endItem()
                })
            })
            break
        default:
            break
        }
    }

    
}
