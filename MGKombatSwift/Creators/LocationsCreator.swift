//
//  LocationsCreator.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 19/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class LocationsCreator : NSObject {
    
    static var shared = LocationsCreator()
    
    public func getAllLocations() -> [FightLocation] {
        var locations : [FightLocation] = []
        
        locations.append(grandCathedral())
        locations.append(rapture())
        locations.append(montalto())
        locations.append(tokyo())
        locations.append(spiritedawaytrain())
        locations.append(berserkeclipse())
        
        return locations
    }
    
    
    public func grandCathedral() -> FightLocation {
        let location : FightLocation = FightLocation.init()
        
        location.name = "Grand Cathedral"
        location.background = UIImage.init(named: "grandcathedral.png")
        location.introAnimation = Animations.AnimationType.none
        location.sound = ""
        
        return location
    }
    
    
    public func rapture() -> FightLocation {
        let location : FightLocation = FightLocation.init()
        
        location.name = "Rapture"
        location.background = UIImage.init(named: "rapture.png")
        location.introAnimation = Animations.AnimationType.none
        location.sound = ""
        
        return location
    }
    
    
    public func montalto() -> FightLocation {
        let location : FightLocation = FightLocation.init()
        
        location.name = "Montalto Dora"
        location.background = UIImage.init(named: "montalto.png")
        location.introAnimation = Animations.AnimationType.none
        location.sound = ""
        
        return location
    }
    
    public func tokyo() -> FightLocation {
        let location : FightLocation = FightLocation.init()
        
        location.name = "Tokyo"
        location.background = UIImage.init(named: "tokyo.png")
        location.introAnimation = Animations.AnimationType.none
        location.sound = ""
        
        return location
    }
    
   
    public func spiritedawaytrain() -> FightLocation {
        let location : FightLocation = FightLocation.init()
        
        location.name = "Treno della città incantata"
        location.background = UIImage.init(named: "spiritedawaytrain.png")
        location.introAnimation = Animations.AnimationType.none
        location.sound = ""
        
        return location
    }
    
    
    public func berserkeclipse() -> FightLocation {
        let location : FightLocation = FightLocation.init()
        
        location.name = "Berserk Eclipse"
        location.background = UIImage.init(named: "berserkeclipse.png")
        location.introAnimation = Animations.AnimationType.none
        location.sound = ""
        
        return location
    }
    
    
}
