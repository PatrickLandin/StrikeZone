//
//  MenuTableViewCell.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell, UICollectionViewDataSource {
  
  @IBOutlet weak var pitcherNameLabel: UILabel!
  @IBOutlet weak var pitcherNumberLabel: UILabel!
  @IBOutlet weak var pitcherImage: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var newMapButton: UIButton!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      self.collectionView.registerNib(UINib(nibName: "MenuCollectionCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "CELL")
      self.collectionView.dataSource = self
      
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 30
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as MenuCollectionViewCell
    
    cell.backgroundColor = UIColor.redColor()
    
    return cell
  }

}
