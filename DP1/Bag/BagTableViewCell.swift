//
//  BagTableViewCell.swift
//  DP1
//
//  Created by Sergii Kotyk on 18/6/21.
//

import UIKit

class BagTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var SizeLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var PhotoImage: UIImageView!
    @IBOutlet weak var NumberOfItemLable: UILabel!
    
    let realmClass = RealmClass()

    func inItCell(data: InBag){
        let imageURL = "https://blackstarwear.ru/" + (data.photo)
        NameLabel.text = data.name
        SizeLabel.text = "размер: \(data.size)"
        PriceLabel.text = "\(Int(Double(data.price)!)) руб."
        PhotoImage.downloaded(from: imageURL)
        PriceLabel.textColor = UIColor.red
        NumberOfItemLable.text = "\(data.numberOfItem) шт."
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
