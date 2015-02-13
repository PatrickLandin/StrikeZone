//
//  Pitcher.swift
//  StrikeZone
//
//  Created by Patrick Landin on 2/12/15.
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
