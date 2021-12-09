//
//  Structs.swift
//  DP1
//
//  Created by Sergii Kotyk on 25/5/21.
//

import Foundation

class Categories1{
    let name: String
    let sortOrder: Int
    let iconImage: String
    let subcategories: NSArray
    
    init?(data: NSDictionary){
        guard let name = data["name"] as? String,
            let sortOrder = data["sortOrder"] as? String,
            let subcategories = data["subcategories"] as? NSArray,
            let iconImage = data["iconImage"] as? String
            else { return nil }
        self.name = name
        self.sortOrder = Int(sortOrder) ?? 0
        self.subcategories = subcategories
        self.iconImage = iconImage
    }
    
    func getSubCategories() -> [Subcategories]{
        var result = [Subcategories]()
        for data in subcategories where data is NSDictionary{
            if let subcategory = Subcategories(data: data as! NSDictionary){
                result.append(subcategory)
            }
        }
        return result
    }
    
}

class Subcategories{
    let name: String
    let sortOrder: Int
    let iconImage: String?
    let id: Int?
    
    init?(data: NSDictionary){
        guard let name = data["name"] as? String,
              let id = data["id"] as? String,
              let sortOrder = data["sortOrder"] as? String,
              let iconImage = data["iconImage"] as? String else { return nil }
        self.name = name
        self.sortOrder = Int(sortOrder) ?? 0
        self.id = Int(id) ?? 0
        self.iconImage = iconImage
     }
}





