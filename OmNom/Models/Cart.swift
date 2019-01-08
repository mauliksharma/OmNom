//
//  Cart.swift
//  OmNom
//
//  Created by Maulik Sharma on 04/01/19.
//  Copyright © 2019 Geekskool. All rights reserved.
//

import UIKit
import CoreData

class Cart {
    
    static var sharedInstance = Cart()
    
    var restaurantID: String?
    var cartItems = [CartItem]()
    
    func loadAllCartItems(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        do {
            cartItems = try context.fetch(request)
            print("cartItems Loaded: \n\(cartItems)")
        } catch {
            print(error)
        }
    }
    
    func addNewCartItem(forItemID itemID: String, in context: NSManagedObjectContext) -> CartItem {
        let cartItem = CartItem(context: context)
        cartItem.itemID = itemID
        cartItem.quantity = 1
        cartItems.append(cartItem)
        return cartItem
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
    
    
    
}
