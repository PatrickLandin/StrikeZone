//
//  HeatMapCollectionViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 2/20/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class HeatMapCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var selectedPitcher : Pitcher!
  var heatMaps : [HeatMap]!
  let heatMap : HeatMap!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      //self.heatMaps = selectedPitcher.heatMaps.allObjects as [HeatMap]
      self.collectionView.dataSource = self
      self.collectionView.delegate = self
      self.collectionView.backgroundColor = UIColor.whiteColor()
      
        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(animated: Bool) {
    self.heatMaps = selectedPitcher.heatMaps.allObjects as [HeatMap]

    self.collectionView.reloadData()
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.heatMaps.count + 1
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HEATMAP_CELL", forIndexPath: indexPath) as HeatMapCollectionViewCell
    cell.heatMapImage.image = nil
    cell.layer.cornerRadius = 10
    cell.layer.borderWidth = 0
    if indexPath.row == 0 {
      
      cell.layer.borderWidth = 1.0
      cell.layer.cornerRadius = 10
      cell.layer.borderColor = UIColor.blueColor().CGColor
    } else {
      let rowNumber = indexPath.row - 1
      let heatMap = heatMaps[rowNumber]
      let image = PitchService.sharedPitchService.convertDataToImage(heatMap.heatMapImage)
      cell.heatMapImage.image = image
    }
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

      performSegueWithIdentifier("SHOW_STRIKEZONE", sender: self)
    
  }
  
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "SHOW_STRIKEZONE" {
      let destinationVC = segue.destinationViewController as StrikeZoneViewController
      let selectedIndexPath = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath
      destinationVC.selectedPitcher = self.selectedPitcher
      var heatMapToPass : HeatMap?
      if selectedIndexPath.row == 0 {
        heatMapToPass = nil
      } else {
      let selectedRow = selectedIndexPath.row - 1
      let heatMapToPass = self.heatMaps[selectedRow]
      destinationVC.currentHeatMap = heatMapToPass
      }
    }
    
  }

}





