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
    self.coreDataStack.managedObjectContext?.save(&pitcherError)
    
    if pitcherError == nil {
      return pitcher
    }
    return nil
  }
  
  func newPitch () -> Pitch? {

    var pitch = NSEntityDescription.insertNewObjectForEntityForName("Pitch", inManagedObjectContext: coreDataStack.managedObjectContext!) as Pitch
    return pitch
  }
  
  
  
}