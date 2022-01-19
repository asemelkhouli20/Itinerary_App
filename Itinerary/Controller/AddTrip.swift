//
//  AddTrip.swift
//  Itinerary
//
//  Created by Asem on 17/01/2022.
//

import Foundation
import UIKit

class AddTrip : UIViewController {
    
    @IBOutlet weak var addimageButton: UIButton!
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var textFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coverImage.layer.cornerRadius=20
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
    }
    
}
