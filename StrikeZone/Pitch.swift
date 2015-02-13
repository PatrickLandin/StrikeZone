//
//  Pitch.swift
//  StrikeZone
//
//  Created by RYAN CHRISTENSEN on 2/12/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import Foundation
import CoreData

class Pitch: NSManagedObject {

    @NSManaged var actualX: NSNumber
    @NSManaged var actualY: NSNumber
    @NSManaged var actualZoneLocation: NSNumber
    @NSManaged var pitchScore: NSNumber
    @NSManaged var pitchType: String
    @NSManaged var targetX: NSNumber
    @NSManaged var targetY: NSNumber
    @NSManaged var targetZoneLocation: NSNumber
    @NSManaged var wasGoodPitch: NSNumber
    @NSManaged var heatMap: StrikeZone.HeatMap

}
