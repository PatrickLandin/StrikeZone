//
//  MenuTableViewCell.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var pitcherNameLabel: UILabel!
  @IBOutlet weak var pitcherImage: UIImageView!
  @IBOutlet weak var newMapButton: UIButton!
  @IBOutlet weak var imageButton: UIButton!
  @IBOutlet weak var numberTextField: UITextField!
  @IBOutlet weak var teamTextField: UITextField!
  @IBOutlet weak var hometownTextField: UITextField!
  @IBOutlet weak var pitchesTextField: UITextField!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      self.pitcherImage.layer.cornerRadius = 7.0
      self.imageButton.layer.cornerRadius = 7.0
      
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
  
}








