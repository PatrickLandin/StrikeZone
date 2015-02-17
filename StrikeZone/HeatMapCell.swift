//
//  HeatMapCell.swift
//  StrikeZone
//
//  Created by Adam Wallraff on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class HeatMapCell: UICollectionViewCell {

  @IBOutlet var imageView: UIImageView!
  
  @IBOutlet var heatMapDateLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      let cellGradiantMaskLayer = CAGradientLayer()
      cellGradiantMaskLayer.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
      cellGradiantMaskLayer.locations = [-1.5]
      cellGradiantMaskLayer.frame = self.bounds
      
      self.imageView.layer.insertSublayer(cellGradiantMaskLayer, atIndex: 1)
      
    }

}
