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
  var number : Int
  var homeTown : String
  var team : String
  var image : UIImage?
  var heatMaps = [HeatMap]()
  
  init (name : String, number : Int, homeTown : String, team : String) {
    self.name = name
    self.number = number
    self.homeTown = homeTown
    self.team = team
  }
}