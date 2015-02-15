//
//  HeatMap.swift
//  StrikeZone
//
//  Created by Adam Wallraff on 2/13/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import Foundation
import CoreData

class HeatMap: NSManagedObject {

    @NSManaged var date: String
    @NSManaged var heatMapImage: NSData
    @NSManaged var heatMapScore: NSNumber
    @NSManaged var pitchCount: NSNumber
    @NSManaged var pitches: NSSet
    @NSManaged var pitcher: Pitcher

}
