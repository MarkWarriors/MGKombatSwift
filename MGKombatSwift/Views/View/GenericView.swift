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
    
    // MARK: LAYOUT INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let customViewNib = loadFromNib()
        customViewNib.frame = bounds
        customViewNib.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(customViewNib)
    }
    
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    

}
