//
//  ProductCollectionViewCell.swift
//  DP1
//
//  Created by Sergii Kotyk on 3/6/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    func initCatCell(item: ProductValue){
        let data = item
        let urlString = "https://blackstarwear.ru/" + (data.mainImage)
        let url = URL(string: urlString)
        NameLabel.text = data.name
        let price = Int(Double(data.price)!)
        priceLabel.text = "\(price) руб."
        mainImage.downloaded(from: url!)
        priceLabel.textColor = UIColor.red
    }
}
