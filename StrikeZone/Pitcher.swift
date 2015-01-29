//
//  Pitcher.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class Pitcher {
  var name : String
  var team : String
  var pitcherImage : UIImage?
  var heatMaps = [HeatMap]()
  
  init (name : String, team : String) {
    self.name = name
    self.team = team
  }
}