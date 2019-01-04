//
//  CartItem.swift
//  OmNom
//
//  Created by Maulik Sharma on 04/01/19.
//  Copyright © 2019 Geekskool. All rights reserved.
//

import UIKit
import CoreData

class CartItem: NSManagedObject {
    
    class func findOrCreateCartItem(forItemID itemID: String, in context: NSManagedObjectContext) throws -> CartItem {
        
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "itemID = %@", itemID)
        do {
            let matches = try context.fetch(request)
            if !matches.isEmpty {
                assert(matches.count == 1, "CartItem.findOrCreateCartItem -- Database Inconsistency")
                return matches.first!
            }
        } catch {
            throw error
        }
        
        let cartItem = CartItem(context: context)
        cartItem.itemID = itemID
        cartItem.quantity = 1
        return cartItem
    }
    
}
