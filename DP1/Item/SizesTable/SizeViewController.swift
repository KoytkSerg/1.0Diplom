//
//  SizeViewController.swift
//  DP1
//
//  Created by Sergii Kotyk on 17/6/21.
//

import UIKit

// всплывающее окно с выбором размера
class SizeViewController: UIViewController {

    @IBOutlet weak var HeaderLable: UILabel!
    @IBOutlet weak var FrameUI: UIView!
    @IBOutlet weak var SizeTableView: UITableView!
    
    var itemInfo: ProductValue? = nil
    var delegate: BagDelegate?
    let realm = RealmClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FrameUI.layer.cornerRadius = 10
        FrameUI.layer.masksToBounds = true
        SizeTableView.layer.cornerRadius = 10
        HeaderLable.font = .boldSystemFont(ofSize: 25)
        realm.inBagResults = realm.realm.objects(InBag.self)
    }
    

   
}
extension SizeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (itemInfo?.offers.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sizeCell", for: indexPath) as! SizeTableViewCell
        let size = self.itemInfo?.offers[indexPath.row]
        cell.textLabel?.text = size!.size
        
        return cell
    }
// сохранение в память при выборе
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inBag = InBag()
        let offer = itemInfo!.offers[indexPath.row]
        if realm.inBagResults?.isEmpty == false{
            let offerID = offer.productOfferID
            let copys = realm.inBagResults?.filter("offerId == \(offerID)")
            if copys?.count == 0{
                try! realm.realm.write{
                inBag.size = offer.size
                inBag.offerId = Int(offer.productOfferID)!
                inBag.name = itemInfo!.name
                inBag.photo = itemInfo!.mainImage
                inBag.price = itemInfo!.price
                realm.realm.add(inBag)
                }
            }
            else{
                try! realm.realm.write{
                    copys?.first?.numberOfItem += 1
                }
            }
        
        }
        else{
            try! realm.realm.write{
            inBag.size = offer.size
            inBag.offerId = Int(offer.productOfferID)!
            inBag.name = itemInfo!.name
            inBag.photo = itemInfo!.mainImage
            inBag.price = itemInfo!.price
            realm.realm.add(inBag)
        }
        }
            
        delegate?.bagButton(true)
        dismiss(animated: true, completion: nil)
    }
}

// протокол для делегата на смену активности кнопки корзины при её первом наполнении
protocol BagDelegate{
    func bagButton(_ bool: Bool)
}
