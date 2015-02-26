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
  @IBOutlet weak var teamLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var historyButton: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
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








