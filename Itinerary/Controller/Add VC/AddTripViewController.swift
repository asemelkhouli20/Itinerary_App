//
//  AddTrip.swift
//  Itinerary
//
//  Created by Asem on 17/01/2022.
//

import Foundation
import UIKit
import Photos
import CoreData

class AddTripViewController : UIViewController {
    
    @IBOutlet weak var addimageButton: UIButton!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var navgationTitle: UILabel!
    @IBOutlet weak var doneButtone: UIButton!
    
    //edit
    var editOn=false
    //to save image from picker view or take it from tripVC if edit mode on
    var tripImage:UIImage?
    //pass back data to tripVC
    var tripModel : TripModels? 
    var update : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.delegate=self
        coverImage.layer.cornerRadius=20
        
        //check if edit mode on - newTrip will have value
        if let trip = tripModel {
            editOn=true
            textFiled.text=trip.name
            coverImage.image=trip.tripImage
            updateCover()
            navgationTitle.text="Edit Trip"
            doneButtone.setTitle("Save", for: .normal)
        }
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImage(_ sender: UIButton) {
        askTheUserToChooseTheSource()
    }
    @IBAction func addPressed(_ sender: UIButton) {
        //make sure text filed not empty and change the text filrd to alert the user
        guard textFiled.text != "", let newTripTitle = textFiled.text else {  textFilrdIsEmpty(); return }
        
        if editOn {
            tripModel?.name=newTripTitle
            tripModel?.tripImage=tripImage
        }else {
            let newTripAdd = TripModels(context: CoreDataBrain.context)
            newTripAdd.name=newTripTitle
            newTripAdd.tripImage=tripImage
            newTripAdd.tripID=UUID()
        }
        CoreDataBrain.saveData()
        //back to main view and pass the data
        if update != nil{ update!()  }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Help methods
    
    //go to sitting
    func goToSetting (){
        let alert = UIAlertController(title: "Photo Library denied", message: "Photo Library access was previosly denied. Please go to settings if you wish to change this", preferredStyle: .alert)
        
        let actionGoToSetting = UIAlertAction(title: "Go To sittings", style: .default) { action in
            DispatchQueue.main.async { if let url = URL(string: UIApplication.openSettingsURLString){ UIApplication.shared.open(url, options: [:], completionHandler: nil)  }    }   }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(actionGoToSetting)
        
        DispatchQueue.main.sync {
            alert.view.tintColor=Help.tintColor
            present(alert, animated: true, completion: nil)
        }
    }
    
    //make alert method
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(action)
        alert.view.tintColor=Help.tintColor
        
        present(alert, animated: true, completion: nil)
    }
    
    //make red border text filed to tell user this filed is required
    func textFilrdIsEmpty() {
        //make warning to user
        textFiled.layer.borderColor=UIColor.red.cgColor
        textFiled.layer.borderWidth=1
        textFiled.layer.cornerRadius=5
        textFiled.placeholder="title trip required"
    }
    
    //present to user sheet and make the user to choose between the resource Camera/Photo Library
    func askTheUserToChooseTheSource() {
        //add image; open image picker to select or take photo from camera
        let imagePuckerSheet = UIAlertController(title: "Slect Source", message: "select the source that you want to take image from it", preferredStyle: .actionSheet)
        //make the action
        let cmeraAction = UIAlertAction(title: "Camera", style: .default) { action in  self.imagePicker(isSourcPhotoType: .camera) }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { action in  self.imagePicker(isSourcPhotoType: .photoLibrary) }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        //add the action
        imagePuckerSheet.addAction(cmeraAction)
        imagePuckerSheet.addAction(photoAction)
        imagePuckerSheet.addAction(cancelAction)
        //change the tint Color to red ‏because blue is default
        imagePuckerSheet.view.tintColor=Help.tintColor
        //present the sheet
        present(imagePuckerSheet, animated: true, completion: nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate , UINavigationControllerDelegate
extension AddTripViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func updateCover() {
        //remove button from show
        coverImage.backgroundColor=UIColor.clear
        addimageButton.tintColor=UIColor.clear
        //update lable
        tripName.text=textFiled.text
        tripName.textColor=UIColor.white
        tripName.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPicerImage = info[.editedImage] as? UIImage {
            coverImage.image = userPicerImage
            self.tripImage=userPicerImage
        }else if let userPicerImage = info[.originalImage] as? UIImage {
            coverImage.image = userPicerImage
            self.tripImage=userPicerImage
        }
        //make lable update
        updateCover()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerController() {
        DispatchQueue.main.sync {
            let myPickerImage=UIImagePickerController()
            myPickerImage.delegate=self
            myPickerImage.allowsEditing=true
            present(myPickerImage, animated: true, completion: nil)}
    }
    //make sure the source are available and make request Authorization and present the picker if user authorized
    func imagePicker(isSourcPhotoType:UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(isSourcPhotoType){
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (statue) in
                switch statue {
                case .authorized:
                    self.presentImagePickerController()
                case .notDetermined:
                    if statue == PHAuthorizationStatus.authorized {
                        self.presentImagePickerController()
                    }
                case .restricted:
                    self.makeAlert(title: "Photo Library Restricted", message: "Photo Library access is restricted and cannot be accessed")
                case .denied:
                    self.goToSetting()
                default:
                    break
                }//end switch
            }//END PHPhotoLibrary
        }else{
            makeAlert(title: "source not available", message: "soory but your device doesn't have this resource")
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension AddTripViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateCover()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField)->Bool {
        if textField.text != "" {
            return true
        } else {
            textFilrdIsEmpty()
            return false
        }
    }
}
