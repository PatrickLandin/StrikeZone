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

        // Do any additional setup after loading the view.
    }

  
  
  //MARK: CollectionView DataSource
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HEAT_MAP_CELL", forIndexPath: indexPath) as HeatMapCell
    
    cell.backgroundColor = UIColor.darkGrayColor()
    
    return cell
    
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //return currentPitcher!.heatMaps.count
    return 5
  }
  
  
  //MARK: CollectionView Delegate
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    //create an action sheet to show options including:
    //Continue selected heatmap
    //delete heat map
    
  }
  
  //MARK: Add Button Pressed
  @IBAction func addHeatMapButtonPushed(sender: AnyObject) {
    
    var newHeatMap = HeatMap()
    currentPitcher?.heatMaps.append(newHeatMap)
    
    //Transition Back to Main Heat Map View with blank heat map
    
  }
}
