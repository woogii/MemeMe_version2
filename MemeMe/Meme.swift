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
    
    struct Keys {
        
        static let BottomText = "bottomText"
        static let TopText = "topText"
        static let OriginalImage = "originalImage"
        static let MemedImage = "memedImage"
    }
    
    @NSManaged var bottomText:String
    @NSManaged var topText:String
    @NSManaged var originalImage:NSData
    @NSManaged var memedImage:NSData
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary : [String:AnyObject], context: NSManagedObjectContext?) {
        let entity = NSEntityDescription.entityForName("Meme", inManagedObjectContext: context!)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        bottomText = dictionary[Keys.BottomText] as! String
        topText    = dictionary[Keys.TopText]  as! String
        originalImage = UIImageJPEGRepresentation(dictionary[Keys.OriginalImage] as! UIImage,1)!
        memedImage  = UIImageJPEGRepresentation(dictionary[Keys.MemedImage] as! UIImage,1)!
        
  
    }
    
}