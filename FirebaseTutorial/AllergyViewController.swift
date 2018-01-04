//
//  AllergyViewController.swift
//  
//
//  Created by Shubhashis Roy on 5/20/17.
//
//

import UIKit
import FirebaseDatabase

class typeCell: UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
}

class AllergyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    var pickerViewData = [String]()
    var dataForSubtitle = [[String]]()
    var rowSelectedInTable: Int = 0
    var subtitleTexts = ["None","None","None","None","None","None"]
    var titleTexts = ["Allergens", "Intolerances", "Specifics", "LifeStyle", "Cultural Restrictions", "Diseases"]
    var selectedRestaurent: Restaurent?
    
    var dbRef: FIRDatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        dbRef = FIRDatabase.database().reference().child("restrictions")
        startObservingDB()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func startObservingDB ()
    {
        dbRef.observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? NSDictionary
            {
                for index in 0...5
                {
                    if let st = dict[self.titleTexts[index].lowercased()] as? String
                    {
                        self.dataForSubtitle.append(self.parseString(st: st, flag: 1 ))
                    }
                }
            }
        })
    }
    
    func parseString(st: String, flag: Int = 0) -> [String]
    {
        
        var tempArray = [String]()
        var temp = ""
        if flag == 1
        {
            tempArray.append("None")
        }
        for character in st.characters
        {
            if character == ","
            {
                temp = temp.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if temp.isEmpty == false
                {
                    tempArray.append(temp)
                }
                temp = ""
            }
            else if character == " " && temp.isEmpty == true
            {
                // Nothing will be done
            }
            else
            {
                temp.append(character)
            }
        }
        if temp.isEmpty == false
        {
            temp = temp.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            tempArray.append(temp)
        }
        return tempArray
    }
    
    @IBAction func enterClicked(_ sender: Any)
    {
        var starters = [String]()
        var meal = [String]()
        var dessert = [String]()
        
        for index in 0...(selectedRestaurent?.foods.count)!-1
        {
            let food = selectedRestaurent?.foods[index]
            let restrictions = self.parseString(st: (selectedRestaurent?.restrictionsOfFood[index])!)
            
            var flag = 1
            for find in subtitleTexts
            {
                if find == "None"
                {
                    continue
                }
                if restrictions.contains(find.lowercased()) == true
                {
                    flag = 0
                    break
                }
            }
            
            if flag == 1
            {
                if restrictions.contains("starters") == true
                {
                    starters.append(food!)
                }
                else if restrictions.contains("meals") == true
                {
                    meal.append(food!)
                }
                else if restrictions.contains("desserts") == true
                {
                    dessert.append(food!)
                }
            }
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectionViewController") as! SelectionViewController
        vc.starter = starters
        vc.lunch = meal
        vc.dessert = dessert
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! typeCell
        cell.title.text = titleTexts[indexPath.row]
        cell.subtitle.text = subtitleTexts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelectedInTable = indexPath.row
        pickerViewData = dataForSubtitle[indexPath.row]
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subtitleTexts[rowSelectedInTable] = dataForSubtitle[rowSelectedInTable][row]
        tableView.reloadData()
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
