//
//  TripModels+CoreDataProperties.swift
//  Itinerary
//
//  Created by Asem on 24/01/2022.
//
//

import Foundation
import CoreData
import UIKit

extension TripModels {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripModels> {
        return NSFetchRequest<TripModels>(entityName: "TripModels")
    }

    @NSManaged public var name: String?
    @NSManaged public var tripID: UUID?
    @NSManaged public var tripImage: UIImage?
    @NSManaged public var dayModels: NSSet?

}

// MARK: Generated accessors for dayModels
extension TripModels {

    @objc(addDayModelsObject:)
    @NSManaged public func addToDayModels(_ value: DayModels)

    @objc(removeDayModelsObject:)
    @NSManaged public func removeFromDayModels(_ value: DayModels)

    @objc(addDayModels:)
    @NSManaged public func addToDayModels(_ values: NSSet)

    @objc(removeDayModels:)
    @NSManaged public func removeFromDayModels(_ values: NSSet)

}

extension TripModels : Identifiable {

}
