//
//  coreData.swift
//  Itinerary
//
//  Created by Asem on 26/01/2022.
//

import UIKit
import CoreData

class CoreDataBrain {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //read
    static public  func fetchTrip() -> [TripModels]? {
        do{
           return try context.fetch(TripModels.fetchRequest())
        }catch{
            print(error)
        }
        return nil
    }
    
    static public func fetchDayModel(with request : NSFetchRequest<DayModels>=DayModels.fetchRequest(),pericate : NSPredicate?=nil,tripId:CVarArg)->[DayModels]?{
        let dayPericate = NSPredicate(format: "childTripModel.tripID == %@",tripId)
        if let addtionalPericate = pericate {
            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [addtionalPericate,dayPericate])
        }
        else {
            request.predicate=dayPericate
        }
        do{
            return try CoreDataBrain.context.fetch(request)
        }catch{print(error)
            
        }
        return nil
    }
    
    
    static public func fetchActavatyModel(with request : NSFetchRequest<ActivityModel>=ActivityModel.fetchRequest(),pericate : NSPredicate?=nil,selectDay:Int,dayId:CVarArg) -> [ActivityModel]?{
        let activatyPericate = NSPredicate(format: "childDayModel.dayID == %@",dayId)
        if let addtionalPericate = pericate {
            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [addtionalPericate,activatyPericate])
        }
        else {
            request.predicate=activatyPericate
        }
        request.sortDescriptors = [NSSortDescriptor(key: "activityTag", ascending: true)]
        do{
            return try CoreDataBrain.context.fetch(request)
        }catch{print(error)
            
        }
        return nil
    }
    
    //write
    static public func saveData(){
        do{ try self.context.save() }catch{ print("saveData error",error) }
    }
    
    
    
}
