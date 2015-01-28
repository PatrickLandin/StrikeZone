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
  @IBOutlet weak var pitcherImage: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var newMapButton: UIButton!
  @IBOutlet weak var imageButton: UIButton!
  @IBOutlet weak var numberTextField: UITextField!
  @IBOutlet weak var teamTextField: UITextField!
  @IBOutlet weak var hometownTextField: UITextField!
  @IBOutlet weak var pitchesTextField: UITextField!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      self.collectionView.registerNib(UINib(nibName: "MenuCollectionCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "CELL")
      self.pitcherImage.layer.cornerRadius = 7.0
      self.imageButton.layer.cornerRadius = 7.0
      self.collectionView.backgroundColor = UIColor.whiteColor()
      self.collectionView.dataSource = self
      
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  //MARK: Textfield Return
  func textFieldShouldReturn(textField: UITextField!) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  //MARK: CollectionView DataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as MenuCollectionViewCell
    
    cell.backgroundColor = UIColor.grayColor()
    cell.layer.cornerRadius = 7.0
    
    return cell
  }

}
