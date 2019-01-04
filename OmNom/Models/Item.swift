//
//  Item.swift
//  OmNom
//
//  Created by Maulik Sharma on 02/01/19.
//  Copyright © 2019 Geekskool. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Item {
    var id: String?
    var name: String?
    var description: String?
    var price: Double?
    var imgURLString: String?
    
    init(json: JSON) {
        id = json["id"].string
        name = json["name"].string
        description = json["description"].string
        price = json["price"].double
        imgURLString = json["img"].string
    }
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        guard let lhsID = lhs.id, let rhsID = rhs.id else { return false }
        return lhsID == rhsID
    }
    
}
