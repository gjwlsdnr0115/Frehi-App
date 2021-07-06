//
//  HomeViewController.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/05.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var foodInfoTableView: UITableView!
    @IBOutlet weak var foodSearchBar: UISearchBar!
    
    var token: NSObjectProtocol!

    
    let list = DummyData.generateData()
    var foodData = [FoodEntity]()
    let dateFormatter = SharedDateFormatter()
    var today: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        foodInfoTableView.backgroundColor = UIColor.white
        foodInfoTableView.tableFooterView = UIView(frame: .zero)
        foodInfoTableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        today = dateFormatter.stringToDate(dateString: dateFormatter.format(date: Date()))
        
        reloadData()
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name.NewDataDidInsert, object: nil, queue: .main, using: { [weak self] (noti) in
            self?.reloadData()
            self?.foodInfoTableView.reloadData()
            // implement update UI code
        })
        
        
        
    }
    
    func reloadData() {
        foodData = DataManager.shared.fetchFood()
        foodData.sort { food1, food2 in
            
            let food1Left = dateFormatter.stringToDate(dateString: food1.date!) - today
            let food2Left = dateFormatter.stringToDate(dateString: food2.date!) - today

            return food1Left < food2Left
        }
        
    }
    
    @IBAction func addNewFood(_ sender: Any) {
        let addFoodVC = storyboard?.instantiateViewController(identifier: "AddFoodViewController") as! AddFoodViewController
        addFoodVC.modalPresentationStyle = .overCurrentContext
        present(addFoodVC, animated: false, completion: nil)
    }
    
}


extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodInfoCell", for: indexPath) as! FoodInfoCell
        

        let data = foodData[indexPath.row]
        
        cell.foodNameLabel.text = data.name
        cell.foodCountLabel.text = "\(data.count)"
        
        let remaining = dateFormatter.stringToDate(dateString: data.date!) - today
        if remaining > 0 {
            cell.foodExpireDayLabel.text = "\(remaining)일"
        } else if remaining < 0{
            cell.foodExpireDayLabel.text = "만료"
        } else {
            cell.foodExpireDayLabel.text = "오늘까지"
        }

        
        cell.foodPurchaseDateLabel.text = data.date
        
        if let image = data.image {
            cell.foodImageView.image = UIImage(data: image)
        } else {
            cell.foodImageView.image = UIImage(named: "default_food_image")
        }
        
        return cell
    }
    
    
}


extension NSNotification.Name {
    static let NewDataDidInsert = NSNotification.Name("NewDataDidInsertNotification")
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
        let data2 = DummyData(name: "사과", img: UIImage(named: "default_food_image"), count: 7, date: "2021.6.18", remaining: 2, placed: "fridge")
        
        return [data1, data2]

    }
}
