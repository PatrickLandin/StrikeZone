//
//  PitchService.swift
//  StrikeZone
//
//  Created by Patrick Landin on 2/12/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit
import CoreData


class PitchService {
  
  // Singleton
  class var sharedPitchService : PitchService {
    struct Static {
      static let instance : PitchService = PitchService()
    }
    return Static.instance
  }

  
  var coreDataStack : DataStack
  
  init() {
    self.coreDataStack = DataStack()
  }
  
  func newPitcher(name: String, team: String) -> Pitcher? {
    
    var pitcher = NSEntityDescription.insertNewObjectForEntityForName("Pitcher", inManagedObjectContext: coreDataStack.managedObjectContext!) as Pitcher
    pitcher.name = name
    pitcher.team = team
    
    var pitcherError : NSError?
    self.coreDataStack.managedObjectContext!.save(&pitcherError)
    
    if pitcherError == nil {
      return pitcher
    }
    return nil
  }
  
  func newHeatMap (currentPitcher: Pitcher) -> HeatMap? {
    
    var heatMap = NSEntityDescription.insertNewObjectForEntityForName("HeatMap", inManagedObjectContext: coreDataStack.managedObjectContext!) as HeatMap
    
    heatMap.pitcher = currentPitcher
        
    return heatMap

  }
  
  func newPitch () -> Pitch? {
    var pitch = NSEntityDescription.insertNewObjectForEntityForName("Pitch", inManagedObjectContext: coreDataStack.managedObjectContext!) as Pitch

    return pitch
    
    //return nil
  }
  
  func covertAndSaveImageForPitcher(currentPitcher : Pitcher, image : UIImage) {
    
    println("called")
    let size = CGSize(width: 300, height: 300)
    UIGraphicsBeginImageContext(size)
    image.drawInRect(CGRect(x: 0, y: 0, width: 300, height: 300))
    let smallImage = UIGraphicsGetImageFromCurrentImageContext()
    let imageData = UIImagePNGRepresentation(smallImage)
    
    currentPitcher.pitcherImage = imageData
    var pitcherError : NSError?
    self.coreDataStack.managedObjectContext!.save(&pitcherError)
    
    if pitcherError != nil {
      println("\(pitcherError)")
    }
  }
  
  func covertAndSaveImageForPitcherHeatMaps(currentHeatMap : HeatMap, image : UIImage) {
    println(image.size)
    println(CGImageGetWidth(image.CGImage))
    println(image.scale)
    let imageData = UIImagePNGRepresentation(image)
    
    currentHeatMap.heatMapImage = imageData
    var heatMapError : NSError?
    self.coreDataStack.managedObjectContext?.save(&heatMapError)
    
    if heatMapError != nil {
      println("\(heatMapError)")
    }
  }
  
  func saveEditedPitcher(currentPitcher: Pitcher){
    var savePitcherError : NSError?
    self.coreDataStack.managedObjectContext?.save(&savePitcherError)
    
    if savePitcherError != nil {
      println("\(savePitcherError)")
    }
  }
  
  func josePaniagua(currentPitcher: Pitcher){
    self.coreDataStack.managedObjectContext?.deleteObject(currentPitcher)
    var deletePitcherError : NSError?
    self.coreDataStack.managedObjectContext?.save(&deletePitcherError)
    
    if deletePitcherError != nil {
      println("\(deletePitcherError)")
    }
  }
  
  func convertDataToImage(data : NSData) -> UIImage? {
    let image = UIImage(data : data)
    return image?
  }
  
}