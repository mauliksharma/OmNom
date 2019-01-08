//
//  ItemCollectionViewCell.swift
//  OmNom
//
//  Created by Maulik Sharma on 02/01/19.
//  Copyright © 2019 Geekskool. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var item: Item? {
        didSet {
            updateCell()
        }
    }
    
    func updateCartInstanceHandler(itemID: String) {
        
    }
    
    func updateCell() {
        guard let item = item else { return }
        nameLabel.text = item.name
        priceLabel.text = "₹\(item.price ?? 0.00)"
        descriptionLabel.text = item.description
    }
    
    @IBOutlet var cartInstanceQuantityLabel: UILabel!
    
    @IBAction func updateCartInstance(_ sender: UIButton) {
        guard let itemID = item?.id else { return }
        updateCartInstanceHandler(itemID: itemID)
        
    }
    
}
