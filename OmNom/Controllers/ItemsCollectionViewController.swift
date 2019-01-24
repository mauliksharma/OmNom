//
//  ItemsCollectionViewController.swift
//  OmNom
//
//  Created by Maulik Sharma on 31/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

struct WebConstants {
    static let getItemsAPI = "http://localhost:8000/items"
}

class ItemsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CartInfoDelegate {
    
    var restaurant: Restaurant? {
        didSet {
            title = restaurant?.name
//            getItemsFor(restaurant: )
        }
    }
    var items = [Item]()
    var cart: Cart?
    
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurant = Restaurant(id: "0UMMY13", name: "Ice-cream Corner")
        loadExistingCartIfPresent()
        getItems()
    }
    
    func getItems() {
        Alamofire.AF.request(WebConstants.getItemsAPI, method: .get).responseJSON { [weak self] response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let menuInfo = JSON(value)
                    print(String(describing: menuInfo))
                    self?.loadItems(from: menuInfo)
                }
            } else {
                print(String(describing: response.result.error))
            }
        }
    }
    
    func loadItems(from json: JSON) {
        guard let itemsInfo = json["menu"].array else { return }
        for itemInfo in itemsInfo {
            let item = Item(json: itemInfo)
            print(String(describing: item))
            items.append(item)
        }
        collectionView.reloadData()
    }
    
    func loadExistingCartIfPresent() {
        guard let resID = restaurant?.id, let context = container?.viewContext else { return }
        if let existingCart = try? Cart.findCart(forRestaurantID: resID, in: context), existingCart != nil {
            cart = existingCart!
            print("Loaded existing cart")
        } else {
            print("No existing cart found")
        }
    }
    
    func getCart() -> Cart? {
        if cart != nil {
            return cart!
        }
        guard let resID = restaurant?.id, let context = container?.viewContext else { return nil }
        if Cart.doesAnotherCartExist(in: context) {
            //pop up clear cart alert
            Cart.deleteExistingCart(in: context)
        }
        cart = Cart.createCart(forRestaurantID: resID, in: context)
        return cart!
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        if let itemCVC = cell as? ItemCollectionViewCell {
            itemCVC.cartDelegate = self
            itemCVC.item = items[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
