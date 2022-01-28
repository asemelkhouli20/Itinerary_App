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
    var trips = [TripModels]()
    
    //edit mode on/off if tripForEdit is nill
    var editOnIndex:Int?
    
    //index select trip to pass data after modify it by activatyVC
    var indexForSelectTrip:Int?
    //to defualt tutorial 
    let userInfo = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        if !userInfo.bool(forKey: "userInfo") {
            userInfo.set(true, forKey: "userInfo")
            let tutorial = Tutorial()
            tutorial.markData()
            tutorial.tutorial()
        }
        trips = CoreDataBrain.fetchTrip()!
        tableView.reloadData()
    }
    
    //MARK: - Prepare for segue addTripVC/activatyVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Help.AddTripVC {
            let popup = segue.destination as! AddTripViewController
           //check if edit mode on - Edit mood from Swipe Cell Check MARK -> Swipe Actions delete/edit
            if let index = editOnIndex {
                popup.tripModel=self.trips[index]
            }
            
            popup.update = {
                //take the data from core data
                self.trips = CoreDataBrain.fetchTrip()!
                self.tableView.reloadData()
            }
            
            //make edit mode off
            editOnIndex=nil
        }
        
        else if segue.identifier == Help.ActivatyTableVC{
            let activatyVC = segue.destination as? ActivatyTableViewController
            if let index = indexForSelectTrip {
                activatyVC?.tripModel=self.trips[index]
            }
        }
       
    }
    
    
    //MARK: - Swipe Actions delete/edit
    
    //delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "delete") { (contextualAction, view , actionPerformanc: @escaping (Bool) -> Void) in
            //make alert to make sure is delete it
            let alert = UIAlertController(title: "Delete trip", message: "Are you sure you want to delete this trip : \( self.trips[indexPath.row].name!)", preferredStyle: .alert)
            //delete the elment
            let deleteAction = UIAlertAction(title: "delete", style: .destructive) { action in
                //delete from core Data
                CoreDataBrain.context.delete(self.trips[indexPath.row])
                //delete from view
                self.trips.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //save
                CoreDataBrain.saveData()
                
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
            //give editOnIndex a value so it have now value not nil so edit mode on check MARK -> Prepare for segue addTripVC/activatyVC
            self.editOnIndex=indexPath.row
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
