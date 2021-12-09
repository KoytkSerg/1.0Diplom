//
//  ItemViewController.swift
//  DP1
//
//  Created by Sergii Kotyk on 11/6/21.
//

import UIKit

class ItemViewController: UIViewController {
    
    @IBOutlet weak var BagButton: UIBarButtonItem!
    @IBOutlet weak var InfoTableView: UITableView!
    @IBOutlet weak var PhotoSizeConst: NSLayoutConstraint!
    @IBOutlet weak var PhotoCollection: UICollectionView!
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buyButtonOutlet: UIButton!
    
    var itemInfo: ProductValue? = nil
    var isPressed = false
    var infoArray = [String]()
    var sizeSting = ""
    let realmClass = RealmClass()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmClass.bagCheck(realmClass: realmClass, buttonName: BagButton)
        priceLabel.textColor = UIColor.red
        buyButtonOutlet.layer.cornerRadius = 5
        
//создание перечня размеров
        for i in itemInfo!.offers{
            sizeSting += "\(i.size) \n"
        }
        
// создание массива с заголовками для ячеек таблици
        infoArray = ["\((itemInfo?.productDescription) ?? "")", "Доступные размеры:\n\(sizeSting)", "Цвет: \((itemInfo?.colorName) ?? "")"]
        
// настройка PageControl
        PageControl.numberOfPages = (self.itemInfo?.productImages.count)!
        PhotoSizeConst.constant = (UIScreen.main.bounds.height / 2 - 50)
        navigationItem.title = itemInfo?.name

        nameLabel.text = itemInfo?.name
        priceLabel.text = "\(Int(Double(itemInfo!.price)!)) руб."
    }

//ссылка и передача информации о размарах в всплывающее меню
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popSize = segue.destination as? SizeViewController{
            popSize.modalPresentationStyle = .popover
            let popOverSize = popSize.popoverPresentationController
            popOverSize?.delegate = self
            popSize.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 4)
            popSize.itemInfo = itemInfo
            popSize.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        realmClass.bagCheck(realmClass: realmClass, buttonName: BagButton)
    }
}

// настройка таблицы с фотографиями
extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
// проверка на наличее фотографий
        if itemInfo?.productImages.isEmpty == true{
            return 1
        }
        else{
                return itemInfo?.productImages.count ?? 0
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ItemPhotoCell
        
// проверка на наличее фотографий
        if itemInfo?.productImages.isEmpty != true{
            let photo = itemInfo?.productImages[indexPath.item]
            let photoUrl = "https://blackstarwear.ru/" + photo!.imageURL
            cell.PhotoView.downloaded(from: photoUrl)
        }else{
            let photoUrl = "https://blackstarwear.ru/" + itemInfo!.mainImage
            cell.PhotoView.downloaded(from: photoUrl)
        }
        
        self.PageControl.currentPage = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PhotoCollection.bounds.width, height: PhotoCollection.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

// увеличение фотографии при нажатии
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isPressed = !self.isPressed
        
        if isPressed == false{
            UIView.animate(withDuration: 0.5, delay: 0){
            self.PhotoSizeConst.constant = (UIScreen.main.bounds.height / 2 - 50)
                self.InfoTableView.isHidden = false
                self.view.layoutIfNeeded()
                self.PhotoCollection.reloadData()}
        }else{
            UIView.animate(withDuration: 0.5, delay: 0){
            self.InfoTableView.isHidden = true
            self.PhotoSizeConst.constant = (UIScreen.main.bounds.height / 6)
                self.view.layoutIfNeeded()
                self.PhotoCollection.reloadData()}
        }
    }
}

// настройка списка с характеристиками товара
extension ItemViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! ItemTableViewCell
        cell.descriptionLabel.text = infoArray[indexPath.row]
        return cell
    }
}

extension ItemViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension ItemViewController: BagDelegate{
    func bagButton(_ bool: Bool) {
        self.BagButton.isEnabled = bool
    }
    
    
}

