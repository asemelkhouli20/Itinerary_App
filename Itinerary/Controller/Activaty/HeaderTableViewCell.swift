//
//  HeaderTableViewCell.swift
//  Itinerary
//
//  Created by Asem on 21/01/2022.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(dayModel:DayModels){
        title.text=dayModel.title
        subTitle.text=dayModel.subTitle
    }

}
