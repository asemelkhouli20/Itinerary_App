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
        trips.append(Trips(id: UUID(), name: "new zlanda"))
        trips.append(Trips(id: UUID(), name: "new zlanda"))
        trips.append(Trips(id: UUID(), name: "new zlanda"))
        trips.append(Trips(id: UUID(), name: "new zlanda"))
    }

    @IBAction func addTrip(_ sender: UIBarButtonItem) {
        
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
        if indexPath.row == 2 {
            return cell
        }
        cell.backgroundImage.image=UIImage(named: "image")
        cell.backgroundColor=UIColor.clear
      
        return cell
    }
    
    
}
