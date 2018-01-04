//
//  SelectionViewController.swift
//  FirebaseTutorial
//
//  Created by Shubhashis Roy on 5/31/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var starterTextField: UITextField!
    @IBOutlet weak var lunchTextField: UITextField!
    @IBOutlet weak var dessertTextField: UITextField!
    var selectedMeal: Int = 0
    
    var starter = [String]()
    var lunch = [String]()
    var dessert = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.isHidden = true
        
        self.starterTextField.delegate = self
        self.lunchTextField.delegate = self
        self.dessertTextField.delegate = self
        
        selectedMeal = 0;
        
        if starter.isEmpty == true
        {
            starter.append("None")
        }
        
        if lunch.isEmpty == true
        {
            lunch.append("None")
        }
        
        if dessert.isEmpty == true
        {
            dessert.append("None")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        var countRows: Int = 1
        if selectedMeal == 0
        {
            countRows = starter.count
        }
        else if selectedMeal == 1
        {
            countRows = lunch.count
        }
        else if selectedMeal == 2
        {
            countRows = dessert.count
        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var title: String = ""
        if selectedMeal == 0
        {
            title = starter[row]
        }
        else if selectedMeal == 1
        {
            title = lunch[row]
        }
        else if selectedMeal == 2
        {
            title = dessert[row]
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if selectedMeal == 0
        {
            if row < starter.count
            {
                self.starterTextField.text = starter[row]
            }
        }
        else if selectedMeal == 1
        {
            if row < lunch.count
            {
                self.lunchTextField.text = lunch[row]
            }
        }
        else if selectedMeal == 2
        {
            if row < dessert.count
            {
                self.dessertTextField.text = dessert[row]
            }
        }
        pickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == starterTextField
        {
            self.selectedMeal = 0
            self.pickerView.reloadAllComponents()
            self.pickerView.isHidden = false
        }
        else if textField == lunchTextField
        {
            self.selectedMeal = 1
            self.pickerView.reloadAllComponents()
            self.pickerView.isHidden = false
        }
        else if textField == dessertTextField
        {
            self.selectedMeal = 2
            self.pickerView.reloadAllComponents()
            self.pickerView.isHidden = false
        }
        textField.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
