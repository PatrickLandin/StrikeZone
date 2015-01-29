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
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      self.collectionView.dataSource = self
      self.collectionView.backgroundColor = UIColor.whiteColor()
      
      self.collectionView.registerNib(UINib(nibName: "HeatMapCell", bundle: nil), forCellWithReuseIdentifier: "HEAT_MAP_CELL")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HEAT_MAP_CELL", forIndexPath: indexPath) as HeatMapCell
    
    cell.imageView.backgroundColor = UIColor.lightGrayColor()
    cell.heatMapDateLabel.text = "mm/dd/yy"
    
    let cellGradiantMaskLayer = CAGradientLayer()
    cellGradiantMaskLayer.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
    cellGradiantMaskLayer.locations = [-0.6]
    cellGradiantMaskLayer.frame = cell.bounds
    
    cell.imageView.layer.insertSublayer(cellGradiantMaskLayer, atIndex: 1)
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
}
