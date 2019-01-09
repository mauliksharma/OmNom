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
                print("Found the relevant cart")
                return matches.first
            }
        } catch {
            throw error
        }
        return nil
    }
    
    class func doesCartExist(in context: NSManagedObjectContext) -> Bool {
        do {
            let cartCount = try context.count(for: Cart.fetchRequest())
            assert(cartCount <= 1, "Cart.doesCartExist -- Database Inconsistency")
            print("Another cart exists!")
            return cartCount != 0 ? true : false
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
        return cart
    }
    
/*
    
    func loadAllCartItems(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        do {
            cartItems = try context.fetch(request)
            print("cartItems Loaded: \n\(cartItems)")
        } catch {
            print(error)=
        }
    }
    

    
    func findCartItem(forItemID itemID: String) -> CartItem? {
        let matchingCartItems = cartItems.filter { $0.itemID == itemID }
        guard !matchingCartItems.isEmpty else { return nil }
        assert(matchingCartItems.count == 1, "Cart.getCartItem -- Database Inconsistency")
        return matchingCartItems.first
    }
    
    func removeCartItem(_ cartItem: CartItem, in context: NSManagedObjectContext) {
        context.delete(cartItem)
        guard let index = cartItems.index(of: cartItem) else { return }
        cartItems.remove(at: index)
        
    }
    
    func deleteAllCartItems(in context: NSManagedObjectContext) throws {
        for cartItem in cartItems {
            context.delete(cartItem)
        }
        cartItems.removeAll()
    }
    
*/
    
}
