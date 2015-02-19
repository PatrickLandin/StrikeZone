//
//  HeatMapCollectionTableViewCell.swift
//  StrikeZone
//
//  Created by Adam Wallraff on 1/27/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class HeatMapCollectionTableViewCell: UITableViewCell, UICollectionViewDataSource {

  @IBOutlet var collectionView: UICollectionView!
  
  var currentPitcher : Pitcher?
  var currentHeatMap : HeatMap!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      self.collectionView.dataSource = self
      self.collectionView.backgroundColor = UIColor.whiteColor()
      self.collectionView.pagingEnabled = true
      self.collectionView.registerNib(UINib(nibName: "HeatMapCell", bundle: nil), forCellWithReuseIdentifier: "HEAT_MAP_CELL")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HEAT_MAP_CELL", forIndexPath: indexPath) as HeatMapCell
    
    let heatMaps = currentPitcher!.heatMaps.allObjects
    if let heatMap = heatMaps[indexPath.row] as? HeatMap{
      let heatMapImage = PitchService.sharedPitchService.convertDataToImage(heatMap.heatMapImage)
      cell.imageView.image = heatMapImage
      cell.heatMapDateLabel.text = ""

    }

    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentPitcher!.heatMaps.count
  }
}
