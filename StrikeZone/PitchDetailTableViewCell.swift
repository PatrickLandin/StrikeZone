//
//  PitchDetailTableViewCell.swift
//  StrikeZone
//
//  Created by Adam Wallraff on 1/27/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitchDetailTableViewCell: UITableViewCell {

  @IBOutlet var pitchDetailsLabel: UILabel!
  @IBOutlet var pitchNumberLabel: UILabel!
  @IBOutlet var pitchScoreLabel: UILabel!

  
  @IBOutlet var pitchStatusView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
