//
//  ProductViewController.swift
//  DP1
//
//  Created by Sergii Kotyk on 3/6/21.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var EmptyLabel: UILabel!
    @IBOutlet weak var BagButton: UIBarButtonItem!
    @IBOutlet weak var ProductCollectionView: UICollectionView!
    
    var productId = 0
    var product: Product? = nil
    var productValue: [ProductValue]? = nil
    var realmClass = RealmClass()
    let loader = Loader()
    var subCatTitle = ""
    var productInfo: ProductValue? = nil
    var delegate: BackSetings?
    
    func delayCheck(time: Int){
        for i in 2...time{
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(i), execute: {
            if self.product?.isEmpty == nil{
                self.EmptyLabel.isHidden = false
            }else{
                self.EmptyLabel.isHidden = true
            }
            })
         }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
// проверка на наличее субкатегорий
        delayCheck(time: 10)
// сбрасывание настроек на меню с категориями для безопасного возвращения
        delegate?.backSetings(false)
        realmClass.bagCheck(realmClass: realmClass, buttonName: BagButton)
        EmptyLabel.isHidden = true
        let url = "http://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(productId)"
        print("id is \(productId)")
        
// загрузка каталога по субкатегории
        loader.loadProduct(urlString: url) { product in
            self.product = product
            let nonSortedProductValue = [ProductValue](product.values)
            self.productValue = nonSortedProductValue.sorted  {
                $0.sortOrder < $1.sortOrder
            }
           
            self.ProductCollectionView.reloadData()
        }
        if self.product?.isEmpty == true{
            self.EmptyLabel.isHidden = false
        }
        
        navigationItem.title = subCatTitle
        
        
//настройка размеров ячейки и растояния между ними в таблице
        if let layout = self.ProductCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumLineSpacing = 0
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height - 165
            layout.itemSize = CGSize(width: width/2 , height: height/3  )
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            ProductCollectionView.collectionViewLayout = layout
            self.navigationController!.navigationBar.backItem?.title = " "
         }
        
 
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        realmClass.bagCheck(realmClass: realmClass, buttonName: BagButton)
        
    }

}

extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let info = (productValue?[indexPath.item])!
        cell.initCatCell(item: info)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.productInfo = productValue![indexPath.item]
        performSegue(withIdentifier: "showItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? ItemViewController{
            destenation.itemInfo = self.productInfo
        }
    }
}

protocol BackSetings {
    func backSetings(_ bool: Bool)
}
