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
    
    var foodCount = 0
    
    var imageRegistered = false
    var location = 0
    
    let datePicker = UIDatePicker()
    let dateFormatter = SharedDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        createDatePicker()
    }
    
    func createDatePicker() {
        expireDateTextField.textAlignment = .center
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button
        let doneBtn = UIBarButtonItem(title: "완료", style: .done, target: nil, action: #selector(doneToggled))
        toolbar.setItems([doneBtn], animated: true)
        
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
    
    
    @IBAction func addBtnToggled(_ sender: Any) {
        
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
