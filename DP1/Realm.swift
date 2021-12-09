//
//  File.swift
//  DP1
//
//  Created by Sergii Kotyk on 18/6/21.
//

import Foundation
import RealmSwift

// реалмовский класс для хранения информации о товаре в корзине
class InBag: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var offerId: Int = 0
    @objc dynamic var size: String = ""
    @objc dynamic var numberOfItem: Int = 1
}

// технический класс для работы с реалмом
class RealmClass{
    let realm = try! Realm()
    var inBagResults: Results<InBag>?
    
// функция для проверки наличее сохранённых товаров и актевирование кнопки в NavigationController
    
    func bagCheck(realmClass: RealmClass, buttonName: UIBarButtonItem){
        let realmResault = realmClass.realm.isEmpty
        if realmResault == true {
            buttonName.isEnabled = false
        }else{ buttonName.isEnabled = true}
    }
}

