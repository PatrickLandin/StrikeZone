//
//  Pitch.swift
//  StrikeZone
//
//  Created by RYAN CHRISTENSEN on 1/27/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class Pitch  {
  var targetLocation : CGPoint
  var actualLocation : CGPoint
  var targetZoneLocation : Int?
  var actualZoneLocation : Int?
  
  init () {
    self.targetLocation = CGPoint(x: 0.0, y: 0.0)
    self.actualLocation = CGPoint(x: 0.0, y: 0.0)
  }
}
