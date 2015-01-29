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
  
  @IBOutlet var pitchTableView: UITableView!
  
  @IBOutlet var addNewHeatMap: UIBarButtonItem!
  
  var currentPitcher : Pitcher?
  var currentHeatMap : HeatMap?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.pitchTableView.dataSource = self
      self.pitchTableView.delegate = self
      
      self.pitchTableView.registerNib(UINib(nibName: "heatMapCollectionView", bundle: nil), forCellReuseIdentifier: "HEAT_MAP_COLLECTION_CELL")
    
      self.pitchTableView.registerNib(UINib(nibName: "pitchDetailCell", bundle: nil), forCellReuseIdentifier: "PITCH_CELL")
      
      self.currentHeatMap = currentPitcher?.heatMaps.first
      
      self.pitchersNameLabel.text = currentPitcher?.name
      self.pitchCountLabel.text = "\(currentHeatMap!.allPitches.count)"

    }
  
  //MARK: TableView DataSource
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch indexPath.section{
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("HEAT_MAP_COLLECTION_CELL", forIndexPath: indexPath) as HeatMapCollectionTableViewCell
      cell.currentPitcher = self.currentPitcher
      cell.currentHeatMap = self.currentHeatMap
      
      return cell
      
    default:
      let cell = tableView.dequeueReusableCellWithIdentifier("PITCH_CELL", forIndexPath: indexPath) as PitchDetailTableViewCell
  
      cell.pitchNumberLabel.text = "Pitch: \(indexPath.row + 1)"
      cell.pitchDetailsLabel.text = "Pitch Details"
      return cell
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0{
      return 1
    }
    return self.currentHeatMap!.allPitches.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0{
      return "Heat Maps"
    }
    return "Pitch Details"
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 170
    }
    return 44
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  @IBAction func addHeatMapButtonPressed(sender: AnyObject) {
    //send user back to blank heatmap view
    let destinationVC = StrikeZoneViewController()
    if currentHeatMap != nil {
      self.currentPitcher?.heatMaps.insert(currentHeatMap!, atIndex: 0)
    }
    destinationVC.currentHeatMap = self.currentHeatMap
    destinationVC.selectedPitcher = self.currentPitcher
    self.navigationController?.popToViewController(destinationVC, animated: true)
    
    
    
  }
}
