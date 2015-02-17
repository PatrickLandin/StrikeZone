//
//  HeatMap.swift
//  StrikeZone
//
//  Created by Adam Wallraff on 2/17/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import Foundation
import CoreData

class HeatMap: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var heatMapImage: NSData
    @NSManaged var heatMapScore: NSNumber
    @NSManaged var pitchCount: NSNumber
    @NSManaged var pitcher: Pitcher
    @NSManaged var pitches: NSSet

}
