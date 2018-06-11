//
//  SelectLocationVC.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 15/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit

class SelectLocationVC: UIViewController, MGCollectionViewProtocol  {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var fightBtn: UIButton!
    @IBOutlet weak var selectLbl: UILabel!
    @IBOutlet weak var locationsCollectionView: MGCollectionView!
    
    @IBOutlet weak var selectedLocationLbl: UILabel!
    
    var locations : [FightLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = LocationsCreator.shared.getAllLocations()
        selectedLocationLbl.text = ""
        if locationsCollectionView.indexPathsForSelectedItems != nil {
            for indexPath in locationsCollectionView.indexPathsForSelectedItems!{
                locationsCollectionView.deselectItem(at: indexPath, animated: false)
            }
        }
        locationsCollectionView.allowsMultipleSelection = false
        locationsCollectionView.pullToRefresh = false
        locationsCollectionView.cellIdentifier = LocationSelectionCell.Identifier
        locationsCollectionView.cellNib = UINib.init(nibName: LocationSelectionCell.Identifier, bundle: nil)
        locationsCollectionView.protocolDelegate = self
        locationsCollectionView.initWithCellFixedNumberOf((iphonePortrait: 2, iphoneLandscape: 3, ipadPortrait: 3, ipadLandscape: 6), cellProportions:  (width: 1, height: 1), andSpacing: (top: 8, left: 8, bottom: 8, right: 8))
        GameInstance.game.location = nil

        
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
    
    func collectionViewSelected(cell: UICollectionViewCell, withItem item: Any) {
        if let selectedLocation = item as? FightLocation, GameInstance.game.location == nil {
            GameInstance.game.location = selectedLocation
            selectedLocationLbl.text = selectedLocation.name
        }
    }
    
    func collectionViewDeselected(cell: UICollectionViewCell, withItem item: Any) {
        if let selectedLocation = item as? FightLocation, selectedLocation == GameInstance.game.location {
            GameInstance.game.location = nil
            selectedLocationLbl.text = ""
        }
    }
    
    func collectionViewDisplayItem(_ item: Any, inCell cell: UICollectionViewCell) -> UICollectionViewCell {
        if let cell = cell as? LocationSelectionCell{
            cell.generateViewFor(location: item as! FightLocation)
        }
        return cell
    }
    
    func collectionViewRequestDataForPage(page: Int, valuesCallback: @escaping ([Any]?) -> ()) {
        valuesCallback(locations)
    }
    


    

}
