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
        trips.append(Trips(id: UUID(), name: "new zlanda", tripImage: nil))
        trips.append(Trips(id: UUID(), name: "new zlanda", tripImage: UIImage(named: "image")))
        trips.append(Trips(id: UUID(), name: "new zlanda", tripImage: nil))
        trips.append(Trips(id: UUID(), name: "new zlanda", tripImage: UIImage(named: "image")))
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
}

//MARK: - UITableViewDataSource
extension TripsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as! TripsTableViewCell
        cell.title.text = trips[indexPath.row].name
        cell.backgroundImage.image=trips[indexPath.row].tripImage
        cell.backgroundColor=UIColor.clear
      
        return cell
    }
    
    
}
