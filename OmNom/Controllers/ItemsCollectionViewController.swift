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

struct WebConstants {
    static let getItemsaAPI = "http://localhost:8000/items"
}

class ItemsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var vendor: Vendor? {
        didSet {
//            getItemsFor(vendor: ) //Change getItems to this method
        }
    }
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    func getItems() {
        Alamofire.AF.request(WebConstants.getItemsaAPI, method: .get).responseJSON { [weak self] response in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        if let itemCVC = cell as? ItemCollectionViewCell {
            itemCVC.item = items[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

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
