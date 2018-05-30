//
//  FightAbilityTableViewCell.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 25/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class FightAbilityTableViewCell: UITableViewCell {

    @IBOutlet weak var abilityNameLbl: UILabel!
    @IBOutlet weak var abilityNumberLbl: UILabel!
    static let Identifier = "FightAbilityTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateViewFor(action: FightAction){
        self.abilityNameLbl.text = action.name
        self.abilityNumberLbl.text = "\(action.damage)"
    }
    
}
