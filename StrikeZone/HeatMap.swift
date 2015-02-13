//
//  HeatMap.swift
//  StrikeZone
//
//  Created by Patrick Landin on 2/12/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import Foundation
import CoreData

class HeatMap: NSManagedObject {

    @NSManaged var date: String
    @NSManaged var heatMapImage: NSData
    @NSManaged var pitchCount: NSNumber
    @NSManaged var heatMapScore: NSNumber
    @NSManaged var pitcher: Pitcher
    @NSManaged var pitches: NSSet

}
