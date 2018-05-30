//
//  FighterSelectionCell.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class FighterSelectionCell: UICollectionViewCell {

    @IBOutlet weak var fighterImageView: UIImageView!
    @IBOutlet weak var fighterNameLbl: UILabel!
    
    internal static let Identifier = "FighterSelectionCell"
    public var fighter : Fighter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                if GameInstance.game.player == nil {
                    self.backgroundColor = Colors.Green
                }
                else if GameInstance.game.opponent == nil {
                    self.backgroundColor = Colors.Red
                }
            }
            else{
                self.backgroundColor = UIColor.black
            }
        }
    }
    
    func backgroundForSelectedState(){
        if GameInstance.game.player == self.fighter {
            self.backgroundColor = Colors.Green
        }
        else if GameInstance.game.opponent == self.fighter {
            self.backgroundColor = Colors.Red
        }
    }
    
    func generateViewFor(fighter: Fighter){
        self.fighter = fighter
        self.fighterImageView.image = fighter.image
        self.fighterNameLbl.text = fighter.name?.uppercased()
        if isSelected {
            backgroundForSelectedState()
        }
        else {
            self.backgroundColor = UIColor.black
        }
    }

}
