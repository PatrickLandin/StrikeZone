//
//  PitcherDetailViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitcherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  
  @IBOutlet var pitchersNameLabel: UILabel!
  @IBOutlet var pitchCountLabel: UILabel!
  
//  @IBOutlet var heatMapCollectionView: UICollectionView!
  @IBOutlet var pitchTableView: UITableView!
  
  var addButton : UIBarButtonItem!
  var deleteButton : UIBarButtonItem!
  var ContinueButton: UIBarButtonItem!
  
  var currentPitcher : Pitcher?
  
  //MARK:DUMMY PITCHER
  //let dummyPitcher = Pitcher(name: "Clayon Kershaw")
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      self.pitchTableView.dataSource = self
      self.pitchTableView.delegate = self
      
      self.pitchTableView.registerNib(UINib(nibName: "heatMapCollectionView", bundle: nil), forCellReuseIdentifier: "HEAT_MAP_COLLECTION_CELL")
      
      //self.heatMapCollectionView.registerNib(UINib(nibName: "HeatMapCell", bundle: nil), forCellWithReuseIdentifier: "HEAT_MAP_CELL")
      //self.heatMapCollectionView.backgroundColor = UIColor.whiteColor()
    
      self.pitchTableView.registerNib(UINib(nibName: "pitchDetailCell", bundle: nil), forCellReuseIdentifier: "PITCH_CELL")
      
      
      //self.pitchersNameLabel.text = dummyPitcher.name
      
      self.addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed")
      self.deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteButtonPressed")
      self.ContinueButton = UIBarButtonItem(title: "Continue", style: .Plain, target: self, action: "continueButtonPressed")

//      self.navigationItem.rightBarButtonItem = self.shareButton

    }

  
  
//  //MARK: CollectionView DataSource
//  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HEAT_MAP_CELL", forIndexPath: indexPath) as HeatMapCell
//    
//    cell.backgroundColor = UIColor.darkGrayColor()
//    
//    return cell
//    
//  }
//  
//  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return 15
//  }
  
  
  //MARK: CollectionView Delegate
//  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    self.toolbarItems?.append(self.addButton)
//    self.toolbarItems?.append(self.deleteButton)
//    self.toolbarItems?.append(self.ContinueButton)
//  }
  
  //MARK: TableView DataSource
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch indexPath.section{
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("HEAT_MAP_COLLECTION_CELL", forIndexPath: indexPath) as HeatMapCollectionTableViewCell
      
      
      return cell
      
    default:
      let cell = tableView.dequeueReusableCellWithIdentifier("PITCH_CELL", forIndexPath: indexPath) as PitchDetailTableViewCell
      
      cell.pitchNumberLabel.text = "Pitch: \(indexPath.row + 1)"
      cell.pitchDetailsLabel.text = "High and Away"
      
      return cell
    }
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0{
      return 1
    }
    return 5
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0{
      return "Heat Maps"
    }
    return "Pitch Details"
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 90
    }
    return 44
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  
  //MARK: Add Button Pressed
  @IBAction func addHeatMapButtonPushed(sender: AnyObject) {
    
    var newHeatMap = HeatMap()
    //dummyPitcher.heatMaps.append(newHeatMap)
    
    //Transition Back to Main Heat Map View with blank heat map
    
  }
}
