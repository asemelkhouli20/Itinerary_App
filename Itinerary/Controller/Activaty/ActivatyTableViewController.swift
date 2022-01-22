//
//  ActivatyTableViewController.swift
//  Itinerary
//
//  Created by Asem on 21/01/2022.
//

import UIKit

class ActivatyTableViewController: UITableViewController {

    var tripModel : TripModel?
    var addAction:UIAlertAction?
    
    var updateTripsModel:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor=Help.tintColor
        navigationItem.title=tripModel?.name

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let updateTripsModel = updateTripsModel {
            updateTripsModel()
        }
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alertAdd = UIAlertController(title: "New Item", message: "What would you like to add?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let dayAction = UIAlertAction(title: "Day", style: .default,handler: handelDayAction(action:))
        let activatyAction = UIAlertAction(title: "Activity", style: .default, handler: handelActavatyAction(action:))
        
        alertAdd.addAction(cancelAction)
        alertAdd.addAction(dayAction)
        alertAdd.addAction(activatyAction)
        alertAdd.view.tintColor=Help.tintColor
        //for ipad
        alertAdd.popoverPresentationController?.barButtonItem = sender
        //you can't add activaty without day
        activatyAction.isEnabled=tripModel!.days.count > 0
        
        present(alertAdd, animated: true, completion: nil)
    }
    //add day in handel alert : dayAction
    func handelDayAction(action:UIAlertAction){
        var title = UITextField()
        var subTitle = UITextField()
        
        let alert = UIAlertController(title: "Add Day", message: "", preferredStyle: .alert)
        alert.addTextField { textFiled in
            textFiled.placeholder = "enter a day or title"
            textFiled.delegate=self
            title = textFiled
        }
        alert.addTextField { textFiled in
            textFiled.placeholder = "enter a description"
            subTitle=textFiled
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //add day
         addAction = UIAlertAction(title: "Add", style: .default) { action in
             self.tripModel?.days.append(DayModel(title: title.text!, subTitle: subTitle.text!, activaty: []))
             self.tableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction!)
        addAction!.isEnabled=false
        alert.view.tintColor=Help.tintColor
        present(alert, animated: true, completion: nil)
    }
    //add actavity in handel alert : activatyAction
    func handelActavatyAction(action:UIAlertAction) {
        performSegue(withIdentifier: Help.AddActivatyVC, sender: self)
    }
    //MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Help.AddActivatyVC {
            let popup = segue.destination as! AddActivatyViewController
            popup.tripModel=tripModel
            popup.updateTripModel = {
                self.tripModel=popup.tripModel
                self.tableView.reloadData()
            }
        }
    }
    

    // MARK: - Table view data source

    //sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tripModel?.days.count ?? 0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Help.headerCell) as! HeaderTableViewCell
        cell.setup(dayModel: (tripModel?.days[section])!)
        return cell.contentView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    

    //row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tripModel?.days[section].activaty.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Help.activatyCell) as! ActivatyTableViewCell
        cell.setup(activatyModel: (tripModel!.days[indexPath.section].activaty[indexPath.row]))
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
//MARK: - UITextFiledDelgate
extension ActivatyTableViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let titleTextFiled = textField.text as NSString?
        if let replaceText = titleTextFiled?.replacingCharacters(in: range, with: string), replaceText.count>0{ addAction?.isEnabled=true
        }else{addAction?.isEnabled=false}
        
        return true
    }
}
