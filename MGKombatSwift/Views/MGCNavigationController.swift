//
//  MGCNavigationController.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class MGCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MGCNaviagation.controller = self
    }

    


}
