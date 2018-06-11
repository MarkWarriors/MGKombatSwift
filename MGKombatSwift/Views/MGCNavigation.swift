//
//  MGCNavigation.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

final class MGCNaviagation: NSObject, MGALCDelegate {
    
    
    static var shared = MGCNaviagation()
    
    private var controller : MGCNavigationController?
    private var combatScene : CombatSceneVC?
    
    public func setNavigationController(_ controller: MGCNavigationController){
        self.controller = controller
    }
    
    public func back(animated: Bool){
        self.controller?.popViewController(animated: true)
    }
    
    public func showOptions() {
        self.controller?.performSegue(withIdentifier: Segues.options, sender: self)
    }
    
    public func toSelectPlayer(){
        controller?.popToRootViewController(animated: false)
    }
    
    func didTapController(controllerStatus: MGAmznLikeController.ControllerStatus){
        if Audios.shared.isPlaying {
            Audios.shared.pauseAudio()
        }
        else {
            Audios.shared.resumeAudio()
        }
    }

    func didPerformSwipeAction(trigger: MGAmznLikeController.ActionTriggered){
        switch trigger {
        case .leftAction:
            Audios.shared.prevThemeSong()
            break
        case .rightAction:
            Audios.shared.nextThemeSong()
            break
        case .topAction:
            self.showOptions()
            break
        default:
            break
        }
    }
}
