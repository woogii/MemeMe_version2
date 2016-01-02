//
//  Meme.swift
//  MemeMe
//
//  Created by Hyun on 2015. 10. 30..
//  Copyright © 2015년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Meme : NSManagedObject {
    
    @NSManaged var bottomText:String
    @NSManaged var topText:String
    @NSManaged var originalImage:NSData
    @NSManaged var memedImage:NSData
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(context: NSManagedObjectContext?) {
        let entity = NSEntityDescription.entityForName("Meme", inManagedObjectContext: context!)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
    }
    
}