//
//  PitcherDetailViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitcherDetailViewController: UIViewController {

  
  @IBOutlet var pitchersNameLabel: UILabel!
  @IBOutlet var pitchCountLabel: UILabel!
  
  @IBOutlet var heatMapCollectionView: UICollectionView!
  
  @IBOutlet var addHeatMapButton: UIBarButtonItem!
  @IBOutlet var deleteHeatMapButton: UIBarButtonItem!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
