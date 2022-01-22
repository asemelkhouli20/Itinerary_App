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
    var indexSelect=0
    var typeActivatySelecte=0
    var updateTripModel:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource=self
        pickerView.delegate=self
        titleTextFiled.delegate=self
        addButton.isEnabled=false

        // Do any additional setup after loading the view.
    }
    @IBAction func addPressed(_ sender: UIButton) {
        if let title = titleTextFiled.text{
            
            tripModel?.days[indexSelect].activaty.append(ActivatyModel(title: title, subTitle: titleTextFiled.text ?? "", imageActivaty: ActivatyType(rawValue: typeActivatySelecte)!))
            if let updateTripModel = updateTripModel { updateTripModel() }
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelPreede(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func activatyTypeAction(_ sender: UIButton) {
        typeActivaty.forEach { $0.tintColor=UIColor.systemGray}
       
        typeActivatySelecte=sender.tag
        sender.tintColor=Help.tintColor
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
