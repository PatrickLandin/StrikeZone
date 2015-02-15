//
//  Pitcher.swift
//  StrikeZone
//
//  Created by Adam Wallraff on 2/13/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import Foundation
import CoreData

class Pitcher: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var pitcherImage: NSData
    @NSManaged var team: String
    @NSManaged var heatMaps: NSSet

}
