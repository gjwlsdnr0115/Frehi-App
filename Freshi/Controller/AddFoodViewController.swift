//
//  AddFoodViewController.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/06.
//

import UIKit

class AddFoodViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var foodCountLabel: UILabel!
    
    @IBOutlet weak var fridgeBtn: UIButton!
    @IBOutlet weak var freezerBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var foodImageView: UIImageView!
    var imageData: Data?
    
    var foodCount = 0
    var location = 0
    
    let datePicker = UIDatePicker()
    let dateFormatter = SharedDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        createDatePicker()
        foodImageView.layer.cornerRadius = 5
        foodImageView.layer.masksToBounds = true
    }
    
    // set datePicker as inputView for expireDateTextField
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
        expireDateTextField.inputView = datePicker
    }
    
    @objc func doneToggled() {
        
        expireDateTextField.text = "\(dateFormatter.format(date: datePicker.date))"
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func addPhoto(_ sender: Any) {
        let cameraVC = storyboard?.instantiateViewController(identifier: "CameraViewController") as! CameraViewController
        cameraVC.delegate = self
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: true, completion: nil)
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
    
    // save food data in CoreData
    @IBAction func addBtnToggled(_ sender: Any) {
        if let name = nameTextField.text, let date = expireDateTextField.text {
            if !name.isEmpty, !date.isEmpty {
                if let imageData = imageData {
                    print("image exists")
                    DataManager.shared.createFood(name: name, date: date, count: foodCount, location: location, image: imageData) {
                        NotificationCenter.default.post(name: NSNotification.Name.DataDidUpdate, object: nil)
                    }
                    dismiss(animated: false, completion: nil)
                } else {
                    DataManager.shared.createFood(name: name, date: date, count: foodCount, location: location) {
                        NotificationCenter.default.post(name: NSNotification.Name.DataDidUpdate, object: nil)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}

extension AddFoodViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// protocol to recieve image data from CameraViewController
protocol isAbleToRecieveData {
    func passData(data: Data)
}

extension AddFoodViewController: isAbleToRecieveData {
    func passData(data: Data) {
        
        imageData = data
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.image = UIImage(data: data)

    }

}
