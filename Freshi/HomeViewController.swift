//
//  HomeViewController.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/05.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var foodInfoTableView: UITableView!
    
    
    
    let list = DummyData.generateData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        foodInfoTableView.tableFooterView = UIView(frame: .zero)
        foodInfoTableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    

}


extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodInfoCell", for: indexPath) as! FoodInfoCell
        

        
        let data = list[indexPath.row]
        
        cell.foodNameLabel.text = data.name
        cell.foodCountLabel.text = "\(data.count)"
        cell.foodExpireDayLabel.text = "\(data.remaining)일"
        cell.foodPurchaseDateLabel.text = data.date
        
        if let image = data.img {
            cell.foodImageView.image = image
        }
        
        return cell
    }
    
    
}



struct DummyData {
    let name: String
    let img: UIImage?
    let count: Int
    let date: String
    let remaining: Int
    let placed: String
    
    static func generateData() -> [DummyData] {
        let data1 = DummyData(name: "딸기", img: UIImage(named: "strawberry_stock"), count: 3, date: "2021.6.21", remaining: 4, placed: "fridge")
        let data2 = DummyData(name: "사과", img: UIImage(named: "apple_stock"), count: 7, date: "2021.6.18", remaining: 2, placed: "fridge")
        
        return [data1, data2]

    }
}
