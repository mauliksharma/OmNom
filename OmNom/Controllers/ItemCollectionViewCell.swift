//
//  ItemCollectionViewCell.swift
//  OmNom
//
//  Created by Maulik Sharma on 02/01/19.
//  Copyright © 2019 Geekskool. All rights reserved.
//

import UIKit
import CoreData

protocol CartInfoDelegate {
    func getCart() -> Cart?
}

class ItemCollectionViewCell: UICollectionViewCell {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var cartInstanceView: UIView!
    @IBOutlet var cartInstanceQuantityLabel: UILabel!
    
    var cartDelegate: CartInfoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var item: Item? {
        didSet {
            updateCell()
            getCartItemInstanceIfPresent()
        }
    }
    
    func updateCell() {
        guard let item = item else { return }
        nameLabel.text = item.name
        priceLabel.text = "₹\(item.price ?? 0.00)"
        descriptionLabel.text = item.description
    }
    
    var cartItem: CartItem? {
        didSet {
            if cartItem != nil {
                cartInstanceView.isHidden = false
            } else {
                cartInstanceView.isHidden = true
            }
        }
    }
    
    func getCartItemInstanceIfPresent() {
        if let itemID = item?.id, let context = container?.viewContext {
            if let foundCartItem = try? CartItem.findCartItem(forItemID: itemID, in: context) {
                cartItem = foundCartItem
                setCartInstanceQuantityLabel()
            }
        }
    }
    
    func setCartInstanceQuantityLabel() {
        if let quantity = cartItem?.quantity {
            cartInstanceQuantityLabel.text = String(quantity)
        }
    }
    
    @IBAction func addItemToCart(_ sender: UIButton) {
        guard let itemID = item?.id, let cart = cartDelegate?.getCart(), let context = container?.viewContext else { return }
        cartItem = CartItem.addNewCartItem(forItemID: itemID, toCart: cart, in: context)
        saveCartUpdate()
        setCartInstanceQuantityLabel()
    }

    @IBAction func decrementQuantity(_ sender: UIButton) {
        if let cartItem = cartItem, let context = container?.viewContext {
            if cartItem.quantity == 1 {
                CartItem.removeCartItem(cartItem, in: context)
                self.cartItem = nil
            }
            self.cartItem?.quantity -= 1
            saveCartUpdate()
            setCartInstanceQuantityLabel()
        }
        
    }
    
    @IBAction func incrementQuantity(_ sender: UIButton) {
        if let _ = cartItem {
            self.cartItem?.quantity += 1
            saveCartUpdate()
            setCartInstanceQuantityLabel()
        }
    }
    
    func saveCartUpdate() {
        if let context = container?.viewContext {
            do {
                try context.save()
                print("Update saved")
            }
            catch {
                print("Save failed \(error)")
            }
        }
    }
    

    
}
