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
    
    // NotificationCenter Observer token
    var token: NSObjectProtocol!

    var foodData = [FoodEntity]()
    let dateFormatter = SharedDateFormatter()
    var today: Date!
    
    // colors for foodInfoCell
    let greenColor = UIColor(displayP3Red: 17/255.0, green: 211/255.0, blue: 36/255.0, alpha: 1.0)
    let redColor = UIColor(displayP3Red: 255/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)
    let yellowColor = UIColor(displayP3Red: 255/255.0, green: 236/255.0, blue: 88/255.0, alpha: 1.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set tableView UI
        foodInfoTableView.backgroundColor = UIColor.white
        foodInfoTableView.tableFooterView = UIView(frame: .zero)
        foodInfoTableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        // get today's date
        today = dateFormatter.stringToDate(dateString: dateFormatter.format(date: Date()))
        
        // get food data from CoreData
        reloadData()
        
        // add token
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name.NewDataDidInsert, object: nil, queue: .main, using: { [weak self] (noti) in
            self?.reloadData()
            self?.foodInfoTableView.reloadData()
            // implement update UI code
        })
        
        
        
    }
    
    // fetch data
    func reloadData() {
        foodData = DataManager.shared.fetchFood()
        
        // sort food in order of remaining days
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
    
    deinit {
        NotificationCenter.default.removeObserver(token!)
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
        
        
        // set data in foodInfoCell
        cell.foodNameLabel.text = data.name
        cell.foodCountLabel.text = "\(data.count)"
        
        let remaining = dateFormatter.stringToDate(dateString: data.date!) - today  // get remaining days until expiration
        if remaining > 0 {
            cell.foodExpireDayLabel.textColor = greenColor
            cell.foodExpireDayLabel.text = "\(remaining)일 남음"
        } else if remaining < 0{
            cell.foodExpireDayLabel.textColor = redColor
            cell.foodExpireDayLabel.text = "만료"
        } else {
            cell.foodExpireDayLabel.textColor = yellowColor
            cell.foodExpireDayLabel.text = "오늘까지"
        }

        
        cell.foodPurchaseDateLabel.text = data.date
        
        if let image = data.image {
            cell.foodImageView.image = UIImage(data: image)
        } else {
            // no image registered
            cell.foodImageView.image = UIImage(named: "default_food_image")
        }
        
        return cell
    }
    
    
}


extension NSNotification.Name {
    static let NewDataDidInsert = NSNotification.Name("NewDataDidInsertNotification")
}

