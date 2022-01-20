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
        title.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        title.layer.cornerRadius=20
        title.textColor=UIColor.white
        
    }
    func setupCell(trip:Trips){
        title.text = trip.name
        if let image = trip.tripImage {
            backgroundImage.alpha=0.3
            backgroundImage.image=image
            UIView.animate(withDuration: 1) {
                self.backgroundImage.alpha=1
            }
            backgroundColor=UIColor.clear
        }
        else{
            backgroundImage.image=nil
            backgroundImage.backgroundColor=UIColor(named: "backgroundCard")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
