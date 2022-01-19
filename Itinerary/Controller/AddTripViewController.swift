//
//  AddTrip.swift
//  Itinerary
//
//  Created by Asem on 17/01/2022.
//

import Foundation
import UIKit
import Photos

class AddTripViewController : UIViewController {
    
    @IBOutlet weak var addimageButton: UIButton!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var textFiled: UITextField!
    
    var newTrip : Trips!
    var tripImage:UIImage?
    var passData : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.delegate=self
        coverImage.layer.cornerRadius=20
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
        //save new trip
        newTrip=Trips(id: UUID(), name: newTripTitle, tripImage: tripImage)
        //back to main view and pass the data
        if passData != nil{ passData!()  }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Help methods
    
    //make sure the source are available and make request Authorization and present the picker if user authorized
    func imagePicker(isSourcPhotoType:UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(isSourcPhotoType){
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (statue) in
                switch statue {
                case .authorized:
                    //open it in main threed
                    DispatchQueue.main.sync {
                        let myPickerImage=UIImagePickerController()
                        myPickerImage.delegate=self
                        
                        self.present(myPickerImage, animated: true, completion: nil)
                    }
                default:
                    self.makeAlert(title: " privacy error", message: "please allow to access to your resourse to take your image and make it to background to make your trip more Beautiful")
                    break
                }//end switch
            }//END PHPhotoLibrary
        }else{
            makeAlert(title: "source not available", message: "soory but your device doesn't have this resource")
        }
    }
    //make alert method
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(action)
        alert.view.tintColor=UIColor.red
        
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
        imagePuckerSheet.view.tintColor=UIColor.red
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
        if let userPicerImage = info[.originalImage] as? UIImage {
            coverImage.image = userPicerImage
            self.tripImage=userPicerImage
            //make lable update
            updateCover()
            picker.dismiss(animated: true, completion: nil)
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