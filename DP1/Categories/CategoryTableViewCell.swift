//
//  CategoryTableViewCell.swift
//  DP1
//
//  Created by Sergii Kotyk on 1/6/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var CategoryName: UILabel!
    @IBOutlet weak var CategoryImage: UIImageView!
    
    var urlString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initCatCell(item: Categories1){
        let data = item
        let urlString = "https://blackstarwear.ru/" + (data.iconImage)
        let url = URL(string: urlString)
        CategoryName.text = data.name
        CategoryImage.downloaded(from: url!)
    }
    
    func initsubCatCell(item: Subcategories, defaultPic: String){
        let data = item
// проверка на наличее фотографий и установка основной вместо
        if data.iconImage != ""{
            self.urlString = "https://blackstarwear.ru/" + (data.iconImage!)
        }else{
            self.urlString = "https://blackstarwear.ru/" + (defaultPic)
        }
        
        let url = URL(string: urlString)
        CategoryImage.downloaded(from: url!)
        CategoryName.text = data.name
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
