//
//  FighterDetailsVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 13/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class FighterDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var fighterNameLbl: UILabel!
    @IBOutlet weak var fighterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fightAbilityTableView: UITableView!
    @IBOutlet weak var fightAbilityTableViewHeight: NSLayoutConstraint!
    
    public var fighter : Fighter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fighter != nil {
            self.fighterNameLbl.text = fighter?.name?.uppercased()
            self.fighterImageView.image = (fighter?.image)!
        }
        
        self.fightAbilityTableView.register(UINib.init(nibName: FightAbilityTableViewCell.Identifier, bundle: nil), forCellReuseIdentifier: "FightAbilityTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fightAbilityTableViewHeight.constant = CGFloat(((fighter?.actions.count)!) * 44)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        MGCNaviagation.controller?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fighter?.actions.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FightAbilityTableViewCell = fightAbilityTableView.dequeueReusableCell(withIdentifier: FightAbilityTableViewCell.Identifier,
                                                                                   for: indexPath) as! FightAbilityTableViewCell
        cell.generateViewFor(action: (fighter?.actions[indexPath.row])!)
        
        
        return cell
    }
}
