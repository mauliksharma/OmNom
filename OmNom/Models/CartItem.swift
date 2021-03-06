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
    

    class func findCartItem(forItemID itemID: String, inCart cart: Cart, in context: NSManagedObjectContext) throws -> CartItem? {
        
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        let itemPredicate = NSPredicate(format: "itemID = %@", itemID)
        let cartPredicate = NSPredicate(format: "cart = %@", cart)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate, cartPredicate])
        do {
            let matches = try context.fetch(request)
            if !matches.isEmpty {
                assert(matches.count == 1, "CartItem.findCartItem -- Database Inconsistency")
                print("Found CartItem")
                return matches.first
            }
        } catch {
            throw error
        }
        return nil
    }
    
    class func addNewCartItem(forItemID itemID: String, toCart cart: Cart, in context: NSManagedObjectContext) -> CartItem {
        
        let cartItem = CartItem(context: context)
        cartItem.itemID = itemID
        cartItem.cart = cart
        cartItem.quantity = 1
        return cartItem
    }
    
    class func removeCartItem(_ cartItem: CartItem, in context: NSManagedObjectContext) {
        context.delete(cartItem)
    }
}
