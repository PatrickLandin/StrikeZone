//
//  PitcherDetailViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

protocol PitcherDetailDelegate{
  func setPitcher(pitcher : Pitcher?)
  func setHeatMap(heatmap : HeatMap?)
}
// StrikeZoneViewController

class PitcherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var delegate : PitcherDetailDelegate?
  
  @IBOutlet var pitcherHometown: UILabel!
  @IBOutlet var pitchersNameLabel: UILabel!
  @IBOutlet var pitchCountLabel: UILabel!
  
  @IBOutlet var pitcherImageView: UIImageView!
  
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
      
      //self.currentHeatMap = currentPitcher?.heatMaps.first
      
      self.pitchersNameLabel.text = currentPitcher?.name
      self.pitchCountLabel.text = "\(currentHeatMap!.pitches.allObjects.count)"
//      self.pitcherImageView.image = currentPitcher?.pitcherImage
      self.pitcherHometown.text = currentPitcher?.team

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
  
      cell.pitchNumberLabel.text = "Pitch #: \(indexPath.row + 1)"
      let allPitches = currentHeatMap?.pitches.allObjects as [Pitch]
      cell.pitchDetailsLabel.text = allPitches[indexPath.row].pitchType
      //cell.pitchScoreLabel.text = currentHeatMap?.allPitches[indexPath.row].PitchScore;
      
      cell.pitchStatusView.layer.cornerRadius = 30
      if allPitches[indexPath.row].wasGoodPitch == true{
        cell.pitchStatusView.backgroundColor = UIColor.redColor()
      }
      else{
        cell.pitchStatusView.backgroundColor = UIColor.blueColor()

      }
      
      cell.userInteractionEnabled = false
      
      return cell
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0{
      return 1
    }
    return self.currentHeatMap!.pitches.allObjects.count
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
    
    if currentHeatMap != nil {
//      self.currentPitcher?.heatMaps.insert(currentHeatMap!, atIndex: 0)
    }
    
    delegate?.setPitcher(currentPitcher)
    delegate?.setHeatMap(nil)
    
    //self.navigationController?.popToViewController(destinationVC, animated: true)
    self.navigationController?.popViewControllerAnimated(true)
    
  }
}
