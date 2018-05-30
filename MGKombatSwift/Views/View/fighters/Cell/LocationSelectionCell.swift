//
//  LocationSelectionCell.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class LocationSelectionCell: UICollectionViewCell {

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLbl: UILabel!
    
    internal static let Identifier = "LocationSelectionCell"
    internal var location : FightLocation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                self.backgroundColor = Colors.Green
            }
            else{
                self.backgroundColor = UIColor.black
            }
        }
    }
    
    
    func generateViewFor(location: FightLocation){
        self.location = location
        self.locationImageView.image = location.background
        self.locationNameLbl.text = location.name?.uppercased()
//        if GameInstance.game.location == self.location{
//            self.backgroundColor = Colors.Green
//        }
    }

}
