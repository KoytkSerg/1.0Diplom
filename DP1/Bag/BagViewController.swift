//
//  BagViewController.swift
//  DP1
//
//  Created by Sergii Kotyk on 18/6/21.
//

import UIKit

class BagViewController: UIViewController {

    @IBOutlet weak var ButtonOutlet: UIButton!
    @IBOutlet weak var BagTable: UITableView!
    @IBAction func DeleteAllButton(_ sender: Any) {
        
// создание окна подтверждения при удалении всех товаров из таблици
        let alert = UIAlertController(title: "Внимание!", message: "Вы уверенны что хотите удалить все товары из корзины?", preferredStyle: .alert)
        
        let submitButton = UIAlertAction(title: "Да", style: .default) {(action) in
            
//удаление из памяти
            try! self.realmClass.realm.write{
                self.realmClass.realm.deleteAll()
                }
            
// переход на начальный экран с выбором категорий
            self.navigationController?.popToRootViewController(animated: true)
            }
          
        let cancelButton = UIAlertAction(title: "Нет", style: .default) {(action) in
            self.dismiss(animated: true, completion: nil)
            
        }
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    var amount = 0
    let realmClass = RealmClass()
  
// функция для подсчета суммы стоимостей товаров в списке и отображение её на кнопке
    func amountCalc(){
        self.amount = 0
        for i in self.realmClass.inBagResults!{
            self.amount += Int(Double(i.price)!) * i.numberOfItem
        }
        ButtonOutlet.setTitle("Перейти к оплате \(String(amount)) руб.", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realmClass.inBagResults = realmClass.realm.objects(InBag.self)
        amountCalc()
    }
}

extension BagViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmClass.inBagResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BagCell", for: indexPath) as! BagTableViewCell
        let data = self.realmClass.inBagResults![indexPath.row]
        
        cell.inItCell(data: data)
        
        return cell
    }
    
// обработка нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.realmClass.inBagResults![indexPath.row]
        
// создания окна подтверждения удаление товара
        let alert = UIAlertController(title: "Внимание!", message: "Вы уверенны что хотите удалить товар \(data.name)?", preferredStyle: .alert)
        
        let submitButton = UIAlertAction(title: "Да", style: .default) {(action) in
            if data.numberOfItem == 1{
                
            try! self.realmClass.realm.write{
                 self.realmClass.realm.delete(data)
                 self.amountCalc()

// проверка и выход на главный экран если вручную удалили последний товар
                 let realmResault = self.realmClass.realm.isEmpty
                     if realmResault == true {
                        self.navigationController?.popToRootViewController(animated: true)
                        }
                 }
                self.BagTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            else{
                try! self.realmClass.realm.write{
                    data.numberOfItem -= 1
                }
                self.BagTable.reloadData()
                self.amountCalc()
            }
            
            }
          
        let cancelButton = UIAlertAction(title: "Нет", style: .default) {(action) in
            self.dismiss(animated: true, completion: nil)
            self.BagTable.deselectRow(at: indexPath, animated: true)
        }
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}
