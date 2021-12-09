
import Foundation
import Alamofire

class Loader{
//запрос на получение категорий и субкатегорий и парсинг с помощью метода словаря
    func loadCategories1(completion: @escaping ([Categories1], [String]) -> Void){

        AF.request("https://blackstarshop.ru/index.php?route=api/v1/categories").responseJSON { response in
            if let objects = response.value,
                let jsonDict = objects as? NSDictionary{
                                DispatchQueue.main.async {
                                    var categories: [Categories1] = []
                                    var catKeys: [String] = []
                                    for (key, data) in jsonDict where data is NSDictionary{
                                        if let category = Categories1(data: data as! NSDictionary){
                                            categories.append(category)
                                            catKeys.append(key as! String)
                                            }
                                    }

                                    completion(categories, catKeys)
                                 }

            }
        }
    }
    
// запрос на получение информации о товарах в субкатегории и парсинг с помощью Codable протокола
    func loadProduct(urlString: String, completition: @escaping (Product) -> Void) {
        AF.request(urlString).responseDecodable(of: Product.self) { (response) in
            guard let info = response.value
            else { return }
           completition(info)
        }
    }
}
