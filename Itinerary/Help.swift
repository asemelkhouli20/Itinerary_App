//
//  Help.swift
//  Itinerary
//
//  Created by Asem on 21/01/2022.
//

import Foundation
import UIKit

class Help {
    static let tintColor = UIColor(named: "tint")
    static let fledColor = UIColor(named: "fled")
    static let boredColor = UIColor(named: "bored")
    static let backgroundCardColor = UIColor(named: "backgroundCard")
    static let backgroundColor = UIColor(named: "background")
    
    static let ActivatyTableVC = "ActivatyTableViewController"
    static let AddTripVC = "AddTripViewController"
    static let AddActivatyVC = "AddActivatyViewController"
    
    static let tripCell = "tripCell"
    static let headerCell = "header"
    static let activatyCell = "activatyCell"
    
    static func typeActivatyImage(type:ActivatyType)->String{
        switch type {
        case .fly:
            return "fly"
        case .Hotel:
            return "Hotel"
        case .taxi:
            return "taxi"
        case .restaurant:
            return "restaurant"
        case .explore:
            return "explore"
        }
    }
}
