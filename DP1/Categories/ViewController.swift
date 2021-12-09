//
//  ViewController.swift
//  DP1
//
//  Created by Sergii Kotyk on 25/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var CategoryTableView: UITableView!
    @IBOutlet weak var BagButton: UIBarButtonItem!
    @IBOutlet weak var BackButton: UIBarButtonItem!
    @IBAction func BackButtonAction(_ sender: Any) {
        startMenu()
        }
    
    let loader = Loader()
    let realmClass = RealmClass()
    var categoriesValue = [Categories1]()
    var numberOfRows = 0
    var subCat: [Subcategories]? = nil
    var isPressed = false
    var isPressedSub = false
    var defPic = ""
    var noSub = 5785
    var noSubTitle = ""
    var catKeys:[String] = []
    var product: Product? = nil
    
// функция с дефолтными настройками
    func startMenu(){
        self.isPressed = false
        self.isPressedSub = false
        self.numberOfRows = self.categoriesValue.count
        self.BackButton.isEnabled = false
// обнуление субкатегорий для срабатывания условия
        self.subCat = nil
        navigationItem.title = "Категории"
// запрос для получения атегорий и субкатегорий
        self.loader.loadCategories1 {categories, catKeys in
            // создание массива с ключами категорий
            var sorts: [Int] = []
            for i in categories{
                sorts.append(i.sortOrder)
            }
            var res: [Int: String] = [:]
            for i in 0...sorts.count - 1{
               res[sorts[i]] = catKeys[i]
            }
            let sorted = res.sorted { $0.key < $1.key }
            self.catKeys = Array(sorted.map({ $0.value }))
            
            // сортировка по sortOrder
            self.categoriesValue = categories.sorted {
                $0.sortOrder < $1.sortOrder
            }
            self.numberOfRows = self.categoriesValue.count
            self.CategoryTableView.reloadData()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startMenu()
        
//проверка на наличие товаров в корзине
        realmClass.bagCheck(realmClass: realmClass, buttonName: BagButton)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//проверка на наличие товаров в корзине
        realmClass.bagCheck(realmClass: realmClass, buttonName: BagButton)
    }
}

// настройка таблици категорий
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CategoryTableViewCell
        if isPressed == false{ // показ категорий
            let data = categoriesValue[indexPath.row]
            self.defPic = data.iconImage
            cell.initCatCell(item: data)
        }else{ // показ субкатегорий
            let data = subCat?[indexPath.row]
            cell.initsubCatCell(item: data!, defaultPic: self.defPic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
// условия для перехода сразу на товары из категорий
        if isPressed == false{
            let data = categoriesValue[indexPath.row]
            let subData = data.getSubCategories()
            if subData.isEmpty == true{
                self.noSub = Int(catKeys[indexPath.row])!
                self.noSubTitle = data.name
                self.isPressedSub = true
               }
        }

// тригер для перехода отображения субкатегорий в ячейке таблици
        if isPressedSub == false{
            let data = categoriesValue[indexPath.row]
            self.subCat = data.getSubCategories().sorted {
                 $0.sortOrder < $1.sortOrder
                 }
            self.numberOfRows = self.subCat?.count ?? 0
            self.isPressed = true
            self.isPressedSub = true
            self.BackButton.isEnabled = true
            navigationItem.title = data.name
            self.CategoryTableView.reloadData()
        }else{
            performSegue(withIdentifier: "showProductCollection", sender: self)
        }
        self.CategoryTableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? ProductViewController{
            if let info = subCat?[CategoryTableView.indexPathForSelectedRow?.row ?? 0]{
                destenation.product = self.product
                destenation.productId = info.id!
                destenation.subCatTitle = info.name
            }else{
                destenation.delegate = self // тригер делегата что бы при нахатии назад буловные переменные стали в дефолтное состояние
                destenation.productId = self.noSub // передача константных айди для двух категорий
                destenation.subCatTitle = self.noSubTitle
            }
        }
    }
}

// описание делегата
extension ViewController: BackSetings{
    func backSetings(_ bool: Bool) {
        self.isPressed = bool
        self.isPressedSub = bool
    }
}

// расширение UIImageView для легкой и быстрой загрузки картинок
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

