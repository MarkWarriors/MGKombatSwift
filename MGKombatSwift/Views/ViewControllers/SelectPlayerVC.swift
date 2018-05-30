//
//  SelectPlayerVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class SelectPlayerVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var playerDetailsBtn: UIButton!
    @IBOutlet weak var opponentDetailsBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var selectLbl: UILabel!
    @IBOutlet weak var fightersCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedPlayerLbl: UILabel!
    @IBOutlet weak var selectedOpponentLbl: UILabel!
    
    private var fighters : [Fighter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fightersCollectionView.allowsMultipleSelection = true
        self.fightersCollectionView.register(UINib.init(nibName: FighterSelectionCell.Identifier, bundle: nil), forCellWithReuseIdentifier: FighterSelectionCell.Identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fighters = FighterCreator.shared.getAllFighters()
        
        if GameInstance.game.player == nil {
            selectedPlayerLbl.text = ""
            self.playerDetailsBtn.isHidden = true
        }
        
        if GameInstance.game.opponent == nil {
            selectedOpponentLbl.text = ""
            self.opponentDetailsBtn.isHidden = true
        }
        
        if GameInstance.game.player == nil && GameInstance.game.opponent == nil{
            if fightersCollectionView.indexPathsForSelectedItems != nil {
                for indexPath in fightersCollectionView.indexPathsForSelectedItems!{
                    fightersCollectionView.deselectItem(at: indexPath, animated: false)
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Audios.shared.play(audioType: .mainTheme, forceChange: true)
    }
    
    @IBAction func locationBtnTap(_ sender: Any) {
        if GameInstance.game.player != nil && GameInstance.game.opponent != nil{
            goToSelectLocation()
        }
    }
    
    func goToSelectLocation(){
        self.performSegue(withIdentifier: Segues.location, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.fighterDetails {
            let vc : FighterDetailsVC = segue.destination as! FighterDetailsVC
            vc.fighter = sender as? Fighter
        }
    }
    
    
    @IBAction func playerDetailsBtnTap(_ sender: Any) {
        if GameInstance.game.player != nil {
            // TODO: Complete the fighter details
//            self.performSegue(withIdentifier: Segues.fighterDetails, sender: GameInstance.game.player)
        }
    }
    
    @IBAction func opponentDetailsBtnTap(_ sender: Any) {
        if GameInstance.game.opponent != nil {
            self.performSegue(withIdentifier: Segues.fighterDetails, sender: GameInstance.game.opponent)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FighterSelectionCell = fightersCollectionView.dequeueReusableCell(
            withReuseIdentifier: FighterSelectionCell.Identifier,
            for: indexPath) as! FighterSelectionCell
        
        cell.generateViewFor(fighter: (self.fighters[indexPath.row]))
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.fighters.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedFighter = self.fighters[indexPath.row]
        if selectedFighter == GameInstance.game.player {
            GameInstance.game.player = nil
            selectedPlayerLbl.text = ""
//            self.playerDetailsBtn.isHidden = true
        }
        else if selectedFighter == GameInstance.game.opponent {
            GameInstance.game.opponent = nil
            selectedOpponentLbl.text = ""
//            self.opponentDetailsBtn.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return GameInstance.game.player == nil || GameInstance.game.opponent == nil
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedFighter = self.fighters[indexPath.row]
        
        if GameInstance.game.player == nil {
            GameInstance.game.player = selectedFighter
            selectedPlayerLbl.text = selectedFighter.name
//            self.playerDetailsBtn.isHidden = false
        }
        else if GameInstance.game.opponent == nil {
            GameInstance.game.opponent = selectedFighter
            selectedOpponentLbl.text = selectedFighter.name
//            self.opponentDetailsBtn.isHidden = false
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(self.fightersCollectionView.frame.width)/3 - 12
        return CGSize.init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 4, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}
