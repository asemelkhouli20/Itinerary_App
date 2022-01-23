//
//  ActivatyTableViewController.swift
//  Itinerary
//
//  Created by Asem on 21/01/2022.
//

import UIKit

class ActivatyTableViewController: UITableViewController {
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var tripModel : TripModel?
    //Edit mode to addActavatyVC
    var indexSelectActivatyForEdit:IndexPath?
    //pass back the data to tripVC
    var updateTripsModel:(()->())?
    //add action for day model on alert add new day make this button isEnabled=false until the user write at lest one character on textFiled for title on alert
    var addAction:UIAlertAction?
    //handel mode edit table view by using hold touch the table view and end it with press on done that will hidden when edit table view mode off
    @objc func addAnnotation(press:UILongPressGestureRecognizer) {
        tableView.isEditing=true
        doneButton.title="done"
        addButton.isEnabled=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor=Help.tintColor
        navigationItem.title=tripModel?.name
        //handel holde touch
        let pressHolder = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        pressHolder.minimumPressDuration=1.0
        tableView.addGestureRecognizer(pressHolder)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //pass back data when user will out this view
        if let updateTripsModel = updateTripsModel {
            updateTripsModel()
        }
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        //back to edit table view off
        tableView.isEditing=false
        doneButton.title=nil
        addButton.isEnabled=true
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
        //title
        alert.addTextField { textFiled in
            textFiled.placeholder = "enter a day or title"
            textFiled.delegate=self
            title = textFiled
        }
        //subTitle
        alert.addTextField { textFiled in
            textFiled.placeholder = "enter a description"
            subTitle=textFiled
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //add day
        addAction = UIAlertAction(title: "Add", style: .default) { action in
            self.tripModel?.days.append(DayModel(title: title.text!, subTitle: subTitle.text!, activaty: []))
            //animated
            let indexSet = IndexSet(integer: self.tripModel!.days.count-1)
            self.tableView.insertSections(indexSet, with: .left)
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction!)
        
        addAction!.isEnabled=false
        alert.view.tintColor=Help.tintColor
        
        present(alert, animated: true, completion: nil)
    }
    
    //add actavity in handel alert : activatyAction
    func handelActavatyAction(action:UIAlertAction) {
        //we do that on another view in AddActivatyVC
        performSegue(withIdentifier: Help.AddActivatyVC, sender: self)
    }
    
    //MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let popup = segue.destination as! AddActivatyViewController
        popup.tripModel=tripModel
        //check edit mode on
        if indexSelectActivatyForEdit != nil {
            popup.indexSelectActivityForEdit=indexSelectActivatyForEdit
            popup.updateTripModel = {
                self.tripModel=popup.tripModel
                self.tableView.reloadData()
                //make edit mode off after back from addActivatyVC to this view
                self.indexSelectActivatyForEdit=nil
            }
        }else {
            popup.updateTripModel = { //new Activaty
                self.tripModel=popup.tripModel
                //animated
                let indexPath = [IndexPath(row: self.tripModel!.days[popup.indexSelect].activaty.count-1, section: popup.indexSelect)]
                self.tableView.insertRows(at: indexPath, with: .left)
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
    
    //MARK: - Swipe Actions delete/edit
    //delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view,performAction: @escaping (Bool) -> Void) in
            let activaty = self.tripModel?.days[indexPath.section].activaty[indexPath.row]
            //make alert to confirm delete from user
            let alert = UIAlertController(title: "Delete Activaty", message: "are you sure you want delete \(activaty!.title)", preferredStyle: .alert)
            //delete Action
            let deleteAction = UIAlertAction(title: "delete", style: .destructive) { action in
                self.tripModel?.days[indexPath.section].activaty.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                performAction(true)
            }
            
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: {_ in performAction(false)})
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            alert.view.tintColor=Help.tintColor
            
            self.present(alert, animated: true, completion: nil)
        }
        delete.image=UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    //edit
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "edit") { (action, view,performAction: @escaping (Bool) -> Void) in
            //make edit mode on
            self.indexSelectActivatyForEdit = indexPath
            //move to AddActivatyVC and pass the data check MARK -> prepare for segue
            self.performSegue(withIdentifier: Help.AddActivatyVC, sender: self)
        }
        
        edit.backgroundColor=UIColor.systemBlue
        edit.image=UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    //MARK: - table edit mode on move
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let activaty = (tripModel?.days[sourceIndexPath.section].activaty[sourceIndexPath.row])!
        tripModel?.days[sourceIndexPath.section].activaty.remove(at: sourceIndexPath.row)
        tripModel?.days[destinationIndexPath.section].activaty.insert(activaty, at: destinationIndexPath.row)
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
