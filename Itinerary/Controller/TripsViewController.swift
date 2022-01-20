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
            popup.passData = { [weak self] in
                self?.trips.append(popup.newTrip)
                self?.tableView.reloadData()
            }
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
    
}

//MARK: - UITableViewDataSource
extension TripsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as! TripsTableViewCell
        cell.title.text = trips[indexPath.row].name
        if let image = trips[indexPath.row].tripImage {
            cell.backgroundImage.image=image
            cell.backgroundColor=UIColor.clear
        }
        else{
            cell.backgroundImage.image=nil
            cell.backgroundImage.backgroundColor=UIColor(named: "backgroundCard")
        }
        return cell
    }
    
    
}
