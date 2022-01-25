//
//  DayModels+CoreDataProperties.swift
//  Itinerary
//
//  Created by Asem on 24/01/2022.
//
//

import Foundation
import CoreData


extension DayModels {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayModels> {
        return NSFetchRequest<DayModels>(entityName: "DayModels")
    }

    @NSManaged public var dayID: UUID?
    @NSManaged public var subTitle: String?
    @NSManaged public var title: String?
    @NSManaged public var activityModel: NSSet?
    @NSManaged public var childTripModel: TripModels?

}

// MARK: Generated accessors for activityModel
extension DayModels {

    @objc(addActivityModelObject:)
    @NSManaged public func addToActivityModel(_ value: ActivityModel)

    @objc(removeActivityModelObject:)
    @NSManaged public func removeFromActivityModel(_ value: ActivityModel)

    @objc(addActivityModel:)
    @NSManaged public func addToActivityModel(_ values: NSSet)

    @objc(removeActivityModel:)
    @NSManaged public func removeFromActivityModel(_ values: NSSet)

}

extension DayModels : Identifiable {

}
