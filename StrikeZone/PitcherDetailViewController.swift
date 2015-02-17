//
//  PitcherDetailViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

// StrikeZoneViewController

class PitcherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet var pitcherHometown: UILabel!
  @IBOutlet var pitchersNameLabel: UILabel!
  @IBOutlet var pitchCountLabel: UILabel!
  
  @IBOutlet var pitcherImageView: UIImageView!
  
  @IBOutlet var pitchTableView: UITableView!
  
  @IBOutlet var addNewHeatMap: UIBarButtonItem!
  
  
  
  var currentPitcher : Pitcher?
  var currentHeatMap : HeatMap?
  var allPitches : NSArray?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.pitchTableView.dataSource = self
      self.pitchTableView.delegate = self
      
      self.pitchTableView.registerNib(UINib(nibName: "heatMapCollectionView", bundle: nil), forCellReuseIdentifier: "HEAT_MAP_COLLECTION_CELL")
    
      self.pitchTableView.registerNib(UINib(nibName: "pitchDetailCell", bundle: nil), forCellReuseIdentifier: "PITCH_CELL")
      
      //self.currentHeatMap = currentPitcher?.heatMaps.first
      
      self.pitchersNameLabel.text = currentPitcher?.name
  
      
      self.allPitches = currentHeatMap!.pitches.allObjects as [Pitch]
      let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
      self.allPitches = allPitches!.sortedArrayUsingDescriptors([sortDescriptor])
      
      
      if currentHeatMap  != nil {
      self.pitchCountLabel.text = "\(currentHeatMap!.pitches.allObjects.count)"
      }
      else
      {
        self.pitchCountLabel.text = "0"
      }
      
      let pitcherImage = PitchService.sharedPitchService.convertDataToImage(currentPitcher!.pitcherImage)
      self.pitcherImageView.image = pitcherImage
      self.pitcherHometown.text = currentPitcher?.team
      
      let tableGradient = CAGradientLayer()
      tableGradient.colors = [UIColor.clearColor().CGColor, UIColor(red: 0, green: 1, blue: 0, alpha: 1).CGColor]
      tableGradient.locations = [-0.005]
      tableGradient.frame = view.bounds
      self.view.layer.insertSublayer(tableGradient, atIndex: 0)

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
  
      cell.pitchNumberLabel.text = "Pitch #: \(allPitches!.count - indexPath.row)"
      
      let currentPitch = allPitches![indexPath.row] as Pitch
      
      println(currentPitch.pitchType)
      println(currentPitch.pitchScore)
      cell.pitchDetailsLabel.text = currentPitch.pitchType
      cell.pitchScoreLabel.text = "Pitch Score: \(currentPitch.pitchScore)"
      
      cell.pitchStatusView.layer.cornerRadius = 30
      if currentPitch.wasGoodPitch == true{
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
    
    let allPitches = currentHeatMap?.pitches.allObjects as [Pitch]
    
    return allPitches.count
    
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
    if currentHeatMap != nil{
    return 2
    }
    else{
      return 1
    }
  }
  
  @IBAction func addHeatMapButtonPressed(sender: AnyObject) {
    
  }
}
