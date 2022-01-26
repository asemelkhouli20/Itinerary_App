//
//  ActivatyTableViewCell.swift
//  Itinerary
//
//  Created by Asem on 21/01/2022.
//

import UIKit

class ActivatyTableViewCell: UITableViewCell {

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var additionImage: UIImageView!
    @IBOutlet weak var coverView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        additionImage.layer.borderWidth = 2
        additionImage.layer.masksToBounds = false
        additionImage.layer.borderColor = Help.boredColor?.cgColor
        additionImage.layer.cornerRadius = additionImage.frame.height/2
        additionImage.clipsToBounds = true
//TODO: - change to defualt
        additionImage.image=UIImage(named: "image")
        coverView.layer.cornerRadius=20
    }

    func setup(activatyModel:ActivityModel){
        typeImage.image=UIImage(named: Help.activatyType[Int(activatyModel.typeActivity)])
        titleLable.text = activatyModel.title
        subTitleLable.text = activatyModel.subTitle
    }
    
    
    
   
}
