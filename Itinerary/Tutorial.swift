//
//  Tutorial.swift
//  Itinerary
//
//  Created by Asem on 28/01/2022.
//

import UIKit

class Tutorial {
    func newDay(_ title:String,_ subtitle:String,_ tagDay:Int64) -> DayModels {
        let day = DayModels(context: CoreDataBrain.context)
        day.dayID=UUID()
        day.title=title
        day.subTitle=subtitle
        day.tagDay=tagDay
        return day
    }
    func newActivity(_ title:String,_ subTitle:String,_ activityTag:Int64,_ typeActivity:Int16)->ActivityModel{
        let activity = ActivityModel(context: CoreDataBrain.context)
        activity.activatyID=UUID()
        activity.activityTag=activityTag
        activity.title=title
        activity.subTitle=subTitle
        activity.typeActivity=typeActivity
        return activity
    }
     func tutorial() {
        //activity future
        let triptutorialEnter = TripModels(context: CoreDataBrain.context)
        triptutorialEnter.name = "touch here to see activity"
        triptutorialEnter.tripID=UUID()

        //swipe future
        let triptutorial = TripModels(context: CoreDataBrain.context)
        triptutorial.name = "swipe"
        triptutorial.tripID=UUID()
        triptutorial.tripImage=UIImage(named: "swipe")

        //day model
         let day1 = newDay("tutorial day", "press '+' to add more", 0)
        triptutorialEnter.addToDayModels(day1)

        //actavatyModel
         let activity = newActivity("swipe for edit/delete", "right delete, left edit", 0,5)
         day1.addToActivityModel(activity)

        //hold edit table view
         let activityHold = newActivity("hold touch for edit", "hold touch for 1 sec", 1, 5)
        day1.addToActivityModel(activityHold)
        
        CoreDataBrain.saveData()
    }
     func markData(){
        let trip = TripModels(context: CoreDataBrain.context)
        trip.tripID=UUID()
        trip.name="Trip to egypt"
        trip.tripImage=UIImage(named:"egypt")
        //day1
         let day1 = newDay("Day 1", "Set", 0)
         trip.addToDayModels(day1)
        //activaty 1   ["fly","Hotel","taxi","restaurant","explore","help"]
        let actavity1 = newActivity("Cairo International Airp", "Arriving to cairo", 0, 0)
         day1.addToActivityModel(actavity1)
         let actavity2 = newActivity("Take taxi from Cairo Airport", "leave the airport", 1, 2)
          day1.addToActivityModel(actavity2)
         let actavity3 = newActivity("Go to hotel", "Novotel Cairo Airport", 2, 1)
          day1.addToActivityModel(actavity3)
         let actavity4 = newActivity("Eat food in hotel", "Novotel Cairo Airport", 3, 3)
          day1.addToActivityModel(actavity4)
        //
         //day2
         let day2 = newDay("Day 2", "Take fun", 1)
          trip.addToDayModels(day2)
         //activaty
         let actavity12 = newActivity("Eat food in hotel/Street", "Novotel Cairo Airport", 0, 3)
          day2.addToActivityModel(actavity12)
          let actavity22 = newActivity("Take taxi to Cairo Center", "Start take fun", 1, 2)
           day2.addToActivityModel(actavity22)
          let actavity32 = newActivity("Explore the city", "Take fun in cairo Street", 2, 4)
           day2.addToActivityModel(actavity32)
         let actavity221 = newActivity("Take taxi to Hotel", "back to Hotel", 1, 2)
          day2.addToActivityModel(actavity221)
          let actavity42 = newActivity("sleep in Hotel", "Novotel Cairo Airport", 3, 3)
           day2.addToActivityModel(actavity42)
         //
         //day3
         let day3 = newDay("Day 3", "back to home", 2)
          trip.addToDayModels(day3)
         //activaty
         let actavity43 = newActivity("Eat food in hotel", "Novotel Cairo Airport", 0, 3)
          day3.addToActivityModel(actavity43)
         let actavity33 = newActivity("check out from hotel", "Novotel Cairo Airport", 1, 1)
          day3.addToActivityModel(actavity33)
         let actavity23 = newActivity("Take taxi to Cairo Airport", "leave the Hotel", 2, 2)
          day3.addToActivityModel(actavity23)
         let actavity13 = newActivity("Cairo International Airp", "Arriving to cairo", 3, 0)
          day3.addToActivityModel(actavity13)
          
        CoreDataBrain.saveData()
    }
}
