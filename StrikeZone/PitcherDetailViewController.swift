//
//  PitcherDetailViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitcherDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  
  @IBOutlet var pitchersNameLabel: UILabel!
  @IBOutlet var pitchCountLabel: UILabel!
  
  @IBOutlet var heatMapCollectionView: UICollectionView!
  
  @IBOutlet var collectionViewHeaderView: UIView!
  
  var addButton : UIBarButtonItem!
  var deleteButton : UIBarButtonItem!
  var ContinueButton: UIBarButtonItem!
  
  var currentPitcher : Pitcher?
  
  //MARK:DUMMY PITCHER
  let dummyPitcher = Pitcher()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.heatMapCollectionView.dataSource = self
      self.heatMapCollectionView.delegate = self
      
      self.heatMapCollectionView.registerNib(UINib(nibName: "HeatMapCell", bundle: nil), forCellWithReuseIdentifier: "HEAT_MAP_CELL")
      
      self.heatMapCollectionView.backgroundColor = UIColor.whiteColor()
      
      dummyPitcher.name = "Clayton Kershaw"
      self.pitchersNameLabel.text = dummyPitcher.name
      
      
      let cellGradiantMaskLayer = CAGradientLayer()
      cellGradiantMaskLayer.colors = [UIColor.lightGrayColor().CGColor, UIColor.clearColor().CGColor]
      cellGradiantMaskLayer.locations = [-3.0]
      cellGradiantMaskLayer.frame = collectionViewHeaderView.bounds
      
      self.collectionViewHeaderView.layer.insertSublayer(cellGradiantMaskLayer, atIndex: 1)
      
      
      self.addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed")
      self.deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteButtonPressed")
      self.ContinueButton = UIBarButtonItem(title: "Continue", style: .Plain, target: self, action: "continueButtonPressed")

//      self.navigationItem.rightBarButtonItem = self.shareButton

    }

  
  
  //MARK: CollectionView DataSource
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HEAT_MAP_CELL", forIndexPath: indexPath) as HeatMapCell
    
    cell.backgroundColor = UIColor.darkGrayColor()
    
    return cell
    
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //return currentPitcher!.heatMaps.count
    return 15
  }
  
  
  //MARK: CollectionView Delegate
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    self.toolbarItems?.append(self.addButton)
    self.toolbarItems?.append(self.deleteButton)
    self.toolbarItems?.append(self.ContinueButton)
    
  }
  
  
  
  //MARK: Add Button Pressed
  @IBAction func addHeatMapButtonPushed(sender: AnyObject) {
    
    var newHeatMap = HeatMap()
    currentPitcher?.heatMaps.append(newHeatMap)
    
    //Transition Back to Main Heat Map View with blank heat map
    
  }
}
