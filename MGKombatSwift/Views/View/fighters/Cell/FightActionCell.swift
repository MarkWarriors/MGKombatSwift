//
//  FightActionCell.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 14/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class FightActionCell: UICollectionViewCell {

    @IBOutlet weak var fightActionName: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    
    internal static let Identifier = "FightActionCell"
    internal static let cellHeight : Int = 30
    internal var fightAction : FightAction?
    internal var item : FighterItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func generateViewFor(fightAction: FightAction){
        self.fightAction = fightAction
        self.fightActionName.text = fightAction.name?.uppercased()
        self.numberLbl.text = ""
    }
    
    func generateViewFor(item: FighterItem){
        self.item = item
        let name = String(format: "%@", (item.name?.uppercased())!)
        self.fightActionName.text = name
        self.numberLbl.text = String(format: "(x%d)", item.amount)
    }

}
