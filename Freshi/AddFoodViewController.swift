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
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}

extension AddFoodViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
