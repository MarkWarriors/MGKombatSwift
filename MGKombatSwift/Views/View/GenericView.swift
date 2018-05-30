//
//  GenericView.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 14/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class GenericView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let view : UIView? = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)![0] as? UIView
        if view != nil {
            addSubview(view!)
            view?.frame = self.bounds
        }
    }
    
}
