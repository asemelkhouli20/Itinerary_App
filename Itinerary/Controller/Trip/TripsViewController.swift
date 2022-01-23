//
//  ViewController.swift
//  Itinerary
//
//  Created by Asem on 15/01/2022.
//

import UIKit

class TripsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    //data
    var trips = [TripModel]()
    //edit mode on/off if tripForEdit is nill
    var tripForEdit:TripModel?
    var editOnIndex:Int?
    //index select trip to pass data after modify it by activatyVC
    var indexForSelectTrip:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        
        //
        //marke date
        trips.append(TripModel(id: UUID(), name: "Go to Bail", tripImage: nil, days: []))
        trips.append(TripModel(id: UUID(), name: "new zlanda", tripImage: UIImage(named: "image"), days: []))
        trips.append(TripModel(id: UUID(), name: "Trip to cairo", tripImage: nil, days: []))
        trips.append(TripModel(id: UUID(), name: "Sangfora", tripImage: UIImage(named: "image"), days: []))
        //mark data complete
        trips.append(TripModel(id: UUID(), name: "Back From Egypt", tripImage: nil, days: [
            DayModel(title: "Septmper 12", subTitle: "whatch", activaty: [
                ActivatyModel(title: "basketBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "FootBall", subTitle: "play", imageActivaty: .Hotel),
                ActivatyModel(title: "RockBall", subTitle: "play", imageActivaty: .explore),
                ActivatyModel(title: "kaboobBall", subTitle: "play", imageActivaty: .restaurant)
            ]),
            DayModel(title: "Septmper 16", subTitle: "whatch", activaty: [
                ActivatyModel(title: "basketBall", subTitle: "play", imageActivaty: .taxi),
                ActivatyModel(title: "FootBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "RockBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "kaboobBall", subTitle: "play", imageActivaty: .fly)
            ]),
            DayModel(title: "Septmper 20", subTitle: "whatch", activaty: [
                ActivatyModel(title: "basketBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "FootBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "RockBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "kaboobBall", subTitle: "play", imageActivaty: .fly)
            ]),
            DayModel(title: "Septmper 30", subTitle: "whatch", activaty: [
                ActivatyModel(title: "basketBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "FootBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "RockBall", subTitle: "play", imageActivaty: .fly),
                ActivatyModel(title: "kaboobBall", subTitle: "play", imageActivaty: .fly)
            ])
        ]))
    }
    
    //MARK: - Prepare for segue addTripVC/activatyVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Help.AddTripVC {
            let popup = segue.destination as! AddTripViewController
            //pass tripForEdit or nil if it new trip
            popup.tripForEdit=tripForEdit
           //check if edit mode on - Edit mood from Swipe Cell Check MARK -> Swipe Actions delete/edit
            if let index = editOnIndex {
                //edit trip
                popup.passData = { [weak self] in
                    self?.trips[index]=popup.newTrip
                    self?.tableView.reloadData()
                } //end passData
            } else {
                //new trip
                popup.passData = { [weak self] in
                    self?.trips.append(popup.newTrip!)
                    self?.tableView.reloadData()
                } //end passData
            }
            //make edit mode off
            tripForEdit=nil
            editOnIndex=nil
            
        }else if segue.identifier == Help.ActivatyTableVC{
            let activatyVC = segue.destination as? ActivatyTableViewController
            activatyVC?.tripModel=trips[indexForSelectTrip!]
            //after dismass the activatyVC update trip model
            activatyVC?.updateTripsModel = {[weak self] in
                //replace tripModel with trip after modify by activatyVC
                self?.trips[(self!.indexForSelectTrip!)]=activatyVC!.tripModel!
            }
        }
    }
    
    
    //MARK: - Swipe Actions delete/edit
    
    //delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "delete") { (contextualAction, view , actionPerformanc: @escaping (Bool) -> Void) in
            //make alert to make sure is delete it
            let alert = UIAlertController(title: "Delete trip", message: "Are you sure you want to delete this trip : \(self.trips[indexPath.row].name)", preferredStyle: .alert)
            //delete the elment
            let deleteAction = UIAlertAction(title: "delete", style: .destructive) { action in
                self.trips.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                actionPerformanc(true)
            }
            
            //add action
            alert.addAction(deleteAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in actionPerformanc(false) }))
            //change tint color to red
            alert.view.tintColor=Help.tintColor
  
            self.present(alert, animated: true, completion: nil)
        }
        delete.image=UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    //edit
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "edit") { (contextualAction, view,performAction: @escaping (Bool) -> Void) in
            
            //give tripForEdit a value so it have now value not nil so edit mode on check MARK -> Prepare for segue addTripVC/activatyVC
            self.editOnIndex=indexPath.row //save the index too
            self.tripForEdit=self.trips[self.editOnIndex!]
            //go to addTripVC on edit mode on
            self.performSegue(withIdentifier: Help.AddTripVC, sender: nil)
        }
        
        edit.image=UIImage(systemName: "pencil")
        edit.backgroundColor=UIColor.systemBlue
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
}

//MARK: - UITableViewDelegate

extension TripsViewController :UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForSelectTrip=indexPath.row
        performSegue(withIdentifier: Help.ActivatyTableVC, sender: self)
    }
    
}

//MARK: - UITableViewDataSource
extension TripsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Help.tripCell) as! TripsTableViewCell
        cell.setupCell(trip: trips[indexPath.row])
        return cell
    }
    
    
}
