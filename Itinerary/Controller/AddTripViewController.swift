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
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var textFiled: UITextField!
    
    
    var newTrip : Trips!
    var tripImage:UIImage?
    var passData : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coverImage.layer.cornerRadius=20
        
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(isSourcPhotoType:UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(isSourcPhotoType){
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (statue) in
                switch statue {
                case .authorized:
                    //open it in main threed
                    DispatchQueue.main.sync {
                        let myPickerImage=UIImagePickerController()
                        self.present(myPickerImage, animated: true, completion: nil)
                    }
                default: break
                }//end switch
            }//END PHPhotoLibrary
        }else{
            makeAlert(title: "source not available", message: "soory but your device doesn't have this resource")
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        //add image; open image picker to select or take photo from camera
        let imagePuckerSheet = UIAlertController(title: "slect image", message: "", preferredStyle: .actionSheet)
        let cmeraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.imagePicker(isSourcPhotoType: .camera)
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.imagePicker(isSourcPhotoType: .photoLibrary)
        }
        imagePuckerSheet.addAction(cmeraAction)
        imagePuckerSheet.addAction(photoAction)
        imagePuckerSheet.view.tintColor=UIColor.red
        present(imagePuckerSheet, animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        //make sure text filed not empty and change the text filrd to alert the user
        guard textFiled.text != "", let newTripTitle = textFiled.text else {
            textFiled.layer.borderColor=UIColor.red.cgColor
            textFiled.layer.borderWidth=1
            textFiled.layer.cornerRadius=5
            textFiled.placeholder="title trip required"
            return
        }
        //save new trip and back to main view
        newTrip=Trips(id: UUID(), name: newTripTitle, tripImage: tripImage)
        if passData != nil{ passData!()  }
        self.dismiss(animated: true, completion: nil)
    }
    
    //make alert method
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(action)
        alert.view.tintColor=UIColor.red
        
        present(alert, animated: true, completion: nil)
    }
    
}
