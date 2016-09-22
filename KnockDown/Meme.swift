//
//  Meme.swift
//  KnockDown
//
//  Created by Xiaochao Luo on 2016-09-20.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import Foundation
import UIKit


import Foundation
import UIKit
import CoreData


class Meme: NSManagedObject {
    
    @NSManaged var nameTextField: String?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String : String], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entity(forEntityName: "Meme", in: context)!
        super.init(entity: entity, insertInto: context)
        
        // Dictionary
        nameTextField = dictionary["nameTextField"] as String!
        
    }
    
    var memedImage1: UIImage? {
        get {
            return
                ImageCache().imageWithIdentifier(nameTextField)
        }
        set {
            ImageCache().storeImage(newValue, withIdentifier: nameTextField)
        }
    }
    
    
}


//struct Meme {
//    var topString: String?
//    var bottomString: String?
//    var originalImage: UIImage?
//    var memedImage: UIImage!
//}
