//
//  PitcherDetailViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitcherDetailViewController: UIViewController {
  
  var selectedPitcher = Pitcher?()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = selectedPitcher?.name

        // Do any additional setup after loading the view.
    }

}
