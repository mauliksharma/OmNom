//
//  Cart.swift
//  OmNom
//
//  Created by Maulik Sharma on 04/01/19.
//  Copyright © 2019 Geekskool. All rights reserved.
//

import UIKit
import CoreData

class Cart: NSManagedObject {
    
    class func findCart(forRestaurantID resID: String, in context: NSManagedObjectContext) throws -> Cart? {
        
        let request: NSFetchRequest<Cart> = Cart.fetchRequest()
        request.predicate = NSPredicate(format: "restaurantID = %@", resID)
        do {
            let matches = try context.fetch(request)
            if !matches.isEmpty {
                assert(matches.count == 1, "Cart.findCart -- Database Inconsistency")
                return matches.first
            }
        } catch {
            throw error
        }
        return nil
    }
    
    class func doesAnotherCartExist(in context: NSManagedObjectContext) -> Bool {
        do {
            let cartCount = try context.count(for: Cart.fetchRequest())
            assert(cartCount <= 1, "Cart.doesAnotherCartExist -- Database Inconsistency")
            print("Another cart exists!")
            return cartCount > 0 ? true : false
        } catch {
            print(error)
        }
        return false
    }
    
    class func deleteExistingCart(in context: NSManagedObjectContext) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Cart.fetchRequest())
        do {
            try context.execute(deleteRequest)
            print("Deleted previous cart!")
        } catch {
            print(error)
        }
    }
    
    class func createCart(forRestaurantID resID: String, in context: NSManagedObjectContext) -> Cart {
        
        let cart = Cart(context: context)
        cart.restaurantID = resID
        print("New Cart Created")
        return cart
    }
    
}
