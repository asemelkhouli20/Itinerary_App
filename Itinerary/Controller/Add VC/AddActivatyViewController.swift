//
//  AddActivatyViewController.swift
//  Itinerary
//
//  Created by Asem on 22/01/2022.
//

import UIKit

class AddActivatyViewController: UIViewController {
    
    

    @IBOutlet weak var titleTextFiled: UITextField!
    @IBOutlet weak var subTitleTextFiled: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet var typeActivaty: [UIButton]!
    
    
    var tripModel:TripModel?
    //to Type Activaty by defualt = .fly
    var typeActivatySelecte=0
    //for select from picker day(section) by defualt first item
    var indexSelect=0
    ////pass data to ActavatyVC
    var updateTripModel:(()->())?
    
    //Edit mode
    var indexSelectActivityForEdit:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource=self
        pickerView.delegate=self
        titleTextFiled.delegate=self
        // Do any additional setup after loading the view.
        
        //to make sure title not empty check MARK -> UITextFiledDelgate
        addButton.isEnabled=false
        
        //editMode
        if let index = indexSelectActivityForEdit {
            //make addButton Enabled
            addButton.isEnabled=true
            addButton.setTitle("Save", for: .normal)
            //set data to View
            let activaaty=tripModel?.days[index.section].activaty[index.row]
            titleTextFiled.text=activaaty?.title
            subTitleTextFiled.text=activaaty?.subTitle
            //make activaty Type selected on view
            typeActivaty.forEach({$0.tintColor=UIColor.systemGray})
            let selectButton = activaaty?.imageActivaty.rawValue
            typeActivaty.forEach({if $0.tag == selectButton{$0.tintColor=Help.tintColor;typeActivatySelecte=$0.tag}})
            //pass day and make it select it on view
            indexSelect=index.section
            pickerView.selectRow(index.section, inComponent: 0, animated: true)
            
        }
    }
    
     func addNewActivaty(_ title: String) {
        tripModel?.days[indexSelect].activaty.append(ActivatyModel(title: title, subTitle: subTitleTextFiled.text ?? "", imageActivaty: ActivatyType(rawValue: typeActivatySelecte)!))
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        //make sure titleText not nil
        if let title = titleTextFiled.text{
            //check for edit mode
            if let index=indexSelectActivityForEdit{
                if index.section == indexSelect { //in the same day(section)
                    //just update
                    tripModel?.days[indexSelect].activaty[index.row] = ActivatyModel(title: title, subTitle: subTitleTextFiled.text ?? "", imageActivaty: ActivatyType(rawValue: typeActivatySelecte)!)
                }else{//in another day(section)
                    //delete the activity from old place
                    tripModel?.days[index.section].activaty.remove(at: index.row)
                    //and make on in new place on day[selectNew]
                    addNewActivaty(title)
                }
            }else{
                //just add new activaty to the select day and pass all data
                addNewActivaty(title)
            }
            //pass back the data to ActavityVC
            if let updateTripModel = updateTripModel { updateTripModel() }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPreede(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //selected type Actavity and update selected on view
    @IBAction func activatyTypeAction(_ sender: UIButton) {
        //upate view
        typeActivaty.forEach { $0.tintColor=UIColor.systemGray}
        sender.tintColor=Help.tintColor
       //save selected
        typeActivatySelecte=sender.tag
    }
    
}

//MARK: - UIPickerViewDataSource,UIPickerViewDelegate
extension AddActivatyViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tripModel?.days.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tripModel?.days[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //save select day
        indexSelect = row
    }

}

//MARK: - UITextFiledDelgate
extension AddActivatyViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let titleTextFiled = textField.text as NSString?
        if let replaceText = titleTextFiled?.replacingCharacters(in: range, with: string), replaceText.count>0{ addButton?.isEnabled=true
        }else{addButton.isEnabled=false}
        
        return true
    }
    
}
