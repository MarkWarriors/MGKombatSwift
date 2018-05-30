//
//  Animations.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 14/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class Animations: NSObject {
    
    enum AnimationType : Int {
        case none = -1
        case earthquake = 0
        case flashing = 1
        case bigEarthquake = 2
        case earthquakeAndFlashing = 3
        case rotation = 4
        case pulse = 5
    }
    
    static func animate(view: UIView, animationType: AnimationType){
        switch animationType {
        case .none:
            break
        case .earthquake:
            earthquake(view: view)
            break
        case .flashing:
            flashing(view: view)
            break
        case .bigEarthquake:
            bigEarthquake(view: view)
            break
        case .earthquakeAndFlashing:
            earthquakeAndFlashing(view: view)
            break
        case .rotation:
            rotation(view: view)
            break
        case .pulse:
            pulse(view: view)
            break
        }
    }
    
    static func earthquake(view: UIView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        
        view.layer.add(animation, forKey: "position")
    }
    
    static func earthquakeAndFlashing(view: UIView){
        bigEarthquake(view: view)
        flashing(view: view)
    }
    
    static func flashing(view: UIView){
        view.alpha = 1
        var timeCount = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            view.alpha = abs(view.alpha - 1)
            timeCount = timeCount + 0.1
            if timeCount >= 1.0{
                view.alpha = 1
                timer.invalidate()
            }
        }
    }
    
    static func pulse(view: UIView){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.25
        pulse.fromValue = 0.6
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 4
        view.layer.add(pulse, forKey: "transform.scale")
    }
    
    static func rotation(view: UIView){
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat((Double.pi * 2.0) * 3)
        rotateAnimation.duration = 0.8
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.6
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        
        view.layer.add(rotateAnimation, forKey: "transform.rotation")
        view.layer.add(pulse, forKey: "transform.scale")
    }
    
    static func bigEarthquake(view: UIView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - CGFloat(arc4random_uniform(25)), y: view.center.y - CGFloat(arc4random_uniform(25))))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + CGFloat(arc4random_uniform(25)), y: view.center.y + CGFloat(arc4random_uniform(25))))
        
        view.layer.add(animation, forKey: "position")
    }
    

}
