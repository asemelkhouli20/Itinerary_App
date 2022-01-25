//
//  ActivityModel+CoreDataProperties.swift
//  Itinerary
//
//  Created by Asem on 24/01/2022.
//
//

import Foundation
import CoreData


extension ActivityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityModel> {
        return NSFetchRequest<ActivityModel>(entityName: "ActivityModel")
    }

    @NSManaged public var activatyID: UUID?
    @NSManaged public var subTitle: String?
    @NSManaged public var title: String?
    @NSManaged public var typeActivity: Int16
    @NSManaged public var activityTag: Int64
    @NSManaged public var childDayModel: DayModels?

}

extension ActivityModel : Identifiable {

}
