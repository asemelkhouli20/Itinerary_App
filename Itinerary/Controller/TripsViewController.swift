//
//  ViewController.swift
//  Itinerary
//
//  Created by Asem on 15/01/2022.
//

import UIKit

class TripsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var trips = [Trips]()
    
    var tripForEdit:Trips?
    var editOnIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        //marke date
        trips.append(Trips(id: UUID(), name: "Go to Bail", tripImage: nil))
        trips.append(Trips(id: UUID(), name: "new zlanda", tripImage: UIImage(named: "image")))
        trips.append(Trips(id: UUID(), name: "Trip to cairo", tripImage: nil))
        trips.append(Trips(id: UUID(), name: "Sangfora", tripImage: UIImage(named: "image")))
    }
    

    @IBAction func addTrip(_ sender: UIBarButtonItem) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddTrip" {
            let popup = segue.destination as! AddTripViewController
            
            popup.tripForEdit=tripForEdit
            
            if let index = editOnIndex {
                popup.passData = { [weak self] in
                    self?.trips[index]=popup.newTrip
                    self?.tableView.reloadData()
                }
            }else {
                popup.passData = { [weak self] in
                    self?.trips.append(popup.newTrip!)
                    self?.tableView.reloadData()
                }
            }
            tripForEdit=nil
            editOnIndex=nil
        }
    }
    
}

//MARK: - UITableViewDelegate
extension TripsViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
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
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                actionPerformanc(false)
            }))
            alert.view.tintColor=UIColor.red
            self.present(alert, animated: true, completion: nil)
        }
        delete.image=UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    //edit
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "edit") { (contextualAction, view,performAction: @escaping (Bool) -> Void) in
            self.tripForEdit=self.trips[indexPath.row]
            self.editOnIndex=indexPath.row
            self.performSegue(withIdentifier: "toAddTrip", sender: nil)
            
        }
        edit.image=UIImage(systemName: "pencil")
        edit.backgroundColor=UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [edit])
    }
}

//MARK: - UITableViewDataSource
extension TripsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as! TripsTableViewCell
        cell.setupCell(trip: trips[indexPath.row])
        return cell
    }
    
    
}
