//
//  TripsTableViewCell.swift
//  Itinerary
//
//  Created by Asem on 17/01/2022.
//

import UIKit

class TripsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 20
        title.layer.cornerRadius=20
        title.textColor=UIColor.white
    }
    
    func setupCell(trip:TripModels){
        title.text = trip.name
        if let image = trip.tripImage {
            
            title.textColor=UIColor.white
            title.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
            backgroundImage.alpha=0.3
            backgroundImage.image=image
            UIView.animate(withDuration: 1) {
                self.backgroundImage.alpha=1
            }
            backgroundColor=UIColor.clear
        }
        else{
            backgroundImage.image=nil
            backgroundImage.backgroundColor=Help.backgroundCardColor
            title.backgroundColor=UIColor.clear
            title.textColor=Help.boredColor
        }
    }
}
