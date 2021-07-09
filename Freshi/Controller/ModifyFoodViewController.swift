//
//  ModifyFoodViewController.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/08.
//

import UIKit

class ModifyFoodViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var foodCountLabel: UILabel!
    
    @IBOutlet weak var fridgeBtn: UIButton!
    @IBOutlet weak var freezerBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!

    @IBOutlet weak var foodImageView: UIImageView!
    
    var modifyFood: FoodEntity?
    
    var imageData: Data?
    var foodCount = 0
    var location = 0
    
    let datePicker = UIDatePicker()
    let dateFormatter = SharedDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        nameTextField.delegate = self
        view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        createDatePicker()
        setFoodData()
        foodImageView.layer.cornerRadius = 5
        foodImageView.layer.masksToBounds = true
    }
    
    
    func createDatePicker() {
        expireDateTextField.textAlignment = .center
        
        // toolbar
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:44))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        // Done button
        let doneBtn = UIBarButtonItem(title: "완료", style: .done, target: nil, action: #selector(doneToggled))
        
        toolbar.items = [flexibleButton, doneBtn]
        toolbar.sizeToFit()
        
        // assign toolbar to textField
        expireDateTextField.inputAccessoryView = toolbar
        
        // assign datePicker to textField
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_kr")
        
        // set modifying food's date on datePicker
        var date = Date()
        if let foodData = modifyFood {
            date = dateFormatter.stringToDate(dateString: foodData.date!)
        }
        datePicker.date = date
        expireDateTextField.inputView = datePicker
    }
    
    @objc func doneToggled() {
        
        expireDateTextField.text = "\(dateFormatter.format(date: datePicker.date))"
        self.view.endEditing(true)
    }
    
    // set modifying food's data
    func setFoodData() {
        if let foodData = modifyFood {
            
            // set food location
            switch foodData.location {
            case 0:
                fridgeBtn.isSelected = true
                freezerBtn.isSelected = false
                otherBtn.isSelected = false
                location = 0
            case 1:
                fridgeBtn.isSelected = false
                freezerBtn.isSelected = true
                otherBtn.isSelected = false
                location = 1
            case 2:
                fridgeBtn.isSelected = false
                freezerBtn.isSelected = false
                otherBtn.isSelected = true
                location = 2
            default:
                break
            }
            
            // set food name
            nameTextField.text = foodData.name
            
            // set food date
            expireDateTextField.text = foodData.date
            
            // set food count
            foodCount = Int(foodData.count)
            foodCountLabel.text = "\(foodData.count)"
            
            // set image
            if let image = foodData.image {
                imageData = image
                foodImageView.contentMode = .scaleAspectFill
                foodImageView.image = UIImage(data: image)
                
            } else {
                print("no image")
            }
        }
    }
    
    
    // set location of food
    @IBAction func fridgeToggled(_ sender: Any) {
        if location != 0 {
            location = 0
            fridgeBtn.isSelected = true
            freezerBtn.isSelected = false
            otherBtn.isSelected = false
        }
    }
    @IBAction func freezerToggled(_ sender: Any) {
        if location != 1 {
            location = 1
            freezerBtn.isSelected = true
            fridgeBtn.isSelected = false
            otherBtn.isSelected = false
        }
    }
    @IBAction func otherToggled(_ sender: Any) {
        if location != 2 {
            location = 2
            otherBtn.isSelected = true
            freezerBtn.isSelected = false
            fridgeBtn.isSelected = false
            
        }
    }
    
    
    @IBAction func addPhoto(_ sender: Any) {
        let cameraVC = storyboard?.instantiateViewController(identifier: "CameraViewController") as! CameraViewController
        cameraVC.delegate = self
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: true, completion: nil)
    }
    
    // set count of food
    @IBAction func plusCount(_ sender: Any) {
        foodCount += 1
        foodCountLabel.text = "\(foodCount)"
    }
    
    @IBAction func minusCount(_ sender: Any) {
        if foodCount != 0 {
            foodCount -= 1
            foodCountLabel.text = "\(foodCount)"
        }
    }

    @IBAction func modifyBtnToggled(_ sender: Any) {
        if let name = nameTextField.text, let date = expireDateTextField.text , let foodData = modifyFood {
            if !name.isEmpty, !date.isEmpty {
                if let imageData = imageData {
                    DataManager.shared.updateFood(entity: foodData, name: name, date: date, count: foodCount, location: location, image: imageData) {
                        NotificationCenter.default.post(name: NSNotification.Name.DataDidUpdate, object: nil)
                        self.dismiss(animated: false, completion: nil)
                    }
                } else {
                    
                    DataManager.shared.updateFood(entity: foodData, name: name, date: date, count: foodCount, location: location) {
                        NotificationCenter.default.post(name: NSNotification.Name.DataDidUpdate, object: nil)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func deleteBtnToggled(_ sender: Any) {
        if let foodData = modifyFood {
            DataManager.shared.delete(entity: foodData) {
                NotificationCenter.default.post(name: NSNotification.Name.DataDidUpdate, object: nil)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}


extension ModifyFoodViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ModifyFoodViewController: isAbleToRecieveData {
    func passData(data: Data) {
        
        imageData = data
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.image = UIImage(data: data)

    }

}
