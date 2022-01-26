//
//  AddActivatyViewController.swift
//  Itinerary
//
//  Created by Asem on 22/01/2022.
//

import UIKit
import CoreData
class AddActivatyViewController: UIViewController {
    
    

    @IBOutlet weak var titleTextFiled: UITextField!
    @IBOutlet weak var subTitleTextFiled: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet var typeActivaty: [UIButton]!
    
    
    var tripModel:TripModels? {didSet{dayModel = CoreDataBrain.fetchDayModel(tripId: tripModel!.tripID! as CVarArg) }}
    //to Type Activaty by defualt = .fly
    var typeActivatySelecte=0
    //for select from picker day(section) by defualt first item
    var indexSelect=0
    ////pass data to ActavatyVC
    var updateTripModel:(()->())?
    
    //Edit mode
    var indexSelectActivityForEdit:IndexPath?
    
    //coreData
    var dayModel:[DayModels]?
    var activatyModel:[ActivityModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource=self
        pickerView.delegate=self
        titleTextFiled.delegate=self
        // Do any additional setup after loading the view.
        
        //to make sure title not empty check MARK -> UITextFiledDelgate
        addButton.isEnabled=false
        dayModel = CoreDataBrain.fetchDayModel(tripId: tripModel!.tripID! as CVarArg)
        //editMode
        if let index = indexSelectActivityForEdit {
            //make addButton Enabled
            addButton.isEnabled=true
            addButton.setTitle("Save", for: .normal)
            //set data to View
            activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: index.section, dayId: dayModel![index.section].dayID! as CVarArg)
            let actavity = activatyModel?[index.row]
            titleTextFiled.text=actavity?.title
            subTitleTextFiled.text=actavity?.subTitle
            //make activaty Type selected on view
            typeActivaty.forEach({$0.tintColor=UIColor.systemGray})
            let selectButton = Int(actavity!.activityTag)
            typeActivaty.forEach({if $0.tag == selectButton{$0.tintColor=Help.tintColor;typeActivatySelecte=$0.tag}})
            //pass day and make it select it on view
            indexSelect=index.section
            pickerView.selectRow(index.section, inComponent: 0, animated: true)
            
        }
    }
    
     func addNewActivaty(_ title: String) {
         activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: indexSelect, dayId: dayModel![indexSelect].dayID! as CVarArg)
         let newActivityadd = ActivityModel(context: CoreDataBrain.context)
         newActivityadd.activityTag=Int64(activatyModel!.count)
         newActivityadd.title=title
         newActivityadd.activatyID=UUID()
         newActivityadd.subTitle=subTitleTextFiled.text ?? ""
         newActivityadd.typeActivity=Int16(typeActivatySelecte)
         
         dayModel![indexSelect].addToActivityModel(newActivityadd)
         CoreDataBrain.saveData()
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        //make sure titleText not nil
        if let title = titleTextFiled.text{
            //check for edit mode
            if let index=indexSelectActivityForEdit{
                if index.section == indexSelect { //in the same day(section)
                    //just update
                    activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: indexSelect, dayId: dayModel![indexSelect].dayID! as CVarArg)
                    activatyModel![index.row].title = title
                    activatyModel![index.row].subTitle = subTitleTextFiled.text ?? ""
                    activatyModel![index.row].typeActivity = Int16(typeActivatySelecte)
                    CoreDataBrain.saveData()
                }else{//in another day(section)
                    activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: indexSelect, dayId: dayModel![indexSelect].dayID! as CVarArg)
                    //delete the activity from old place
                    dayModel![index.section].removeFromActivityModel(activatyModel![index.row])
                    CoreDataBrain.saveData()
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
        return dayModel?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayModel![row].title
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
