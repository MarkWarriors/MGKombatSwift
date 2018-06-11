//
//  SelectLocationVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class SelectLocationVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var fightBtn: UIButton!
    @IBOutlet weak var selectLbl: UILabel!
    @IBOutlet weak var locationsCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedLocationLbl: UILabel!
    
    var locations : [FightLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsCollectionView.allowsMultipleSelection = false
        locationsCollectionView.register(UINib.init(nibName: LocationSelectionCell.Identifier, bundle: nil), forCellWithReuseIdentifier: LocationSelectionCell.Identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GameInstance.game.location = nil
        locations = LocationsCreator.shared.getAllLocations()
        selectedLocationLbl.text = ""
        if locationsCollectionView.indexPathsForSelectedItems != nil {
            for indexPath in locationsCollectionView.indexPathsForSelectedItems!{
                locationsCollectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }

    @IBAction func fightBtnTap(_ sender: Any) {
        if GameInstance.game.location != nil{
            goToCombatPresentation()
        }
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        GameInstance.game.location = nil
        MGCNaviagation.shared.back(animated: true)
    }
    
    func goToCombatPresentation(){
        self.performSegue(withIdentifier: Segues.presentation, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LocationSelectionCell = locationsCollectionView.dequeueReusableCell(
            withReuseIdentifier: LocationSelectionCell.Identifier,
            for: indexPath) as! LocationSelectionCell
        
        cell.generateViewFor(location:  (self.locations[indexPath.row]))
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.locations.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedLocation = self.locations[indexPath.row]
        if selectedLocation == GameInstance.game.location {
            GameInstance.game.location = nil
            selectedLocationLbl.text = ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedLocation = self.locations[indexPath.row]
        
        if GameInstance.game.location == nil {
            GameInstance.game.location = selectedLocation
            selectedLocationLbl.text = selectedLocation.name
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(self.locationsCollectionView.frame.width)/3 - 12
        return CGSize.init(width: width, height: width*2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 4, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}
