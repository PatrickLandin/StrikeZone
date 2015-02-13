// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

import UIKit

class Pitcher {
  var name : String
  var team : String
  var pitcherImage : UIImage?
  var heatMaps = [HeatMap]()
  
  init (name : String, team : String) {
    self.name = name
    self.team = team
    self.pitcherImage = UIImage(named: "PitcherStraightDealin.jpg")
  }
}

import UIKit

class HeatMap {
  var pitchCount : Int
  var date : String
  var heatMapImage : UIImage?
  var allPitches = [Pitch]()
  
  init () {
    self.pitchCount = 0
    self.date = ""
  }
}

import UIKit

class Pitch  {
  var targetLocation : CGPoint
  var actualLocation : CGPoint
  var targetZoneLocation : Int?
  var actualZoneLocation : Int?
  var pitchType : String
  var wasGoodPitch : Bool?
  
  init () {
    self.targetLocation = CGPoint(x: 0.0, y: 0.0)
    self.actualLocation = CGPoint(x: 0.0, y: 0.0)
    self.pitchType = "Cheddar, stinky cheddar"
  }
}
