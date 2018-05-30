//
//  MGCNavigation.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

final class MGCNaviagation  {
    
    private init() { }
    
    static var controller : MGCNavigationController?
    static var combatScene : CombatSceneVC?
    
    static func toSelectPlayer(){
        controller?.popToRootViewController(animated: false)
    }
}
