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
    
    //take tripModel from TripVC
    var tripModel : TripModels? {
        didSet{
            dayModel = CoreDataBrain.fetchDayModel(tripId: tripModel!.tripID! as CVarArg)
        }
    }
    
    //Edit mode to addActavatyVC
    var indexSelectActivatyForEdit:IndexPath?
    
    //add action for day model on alert add new day make this button isEnabled=false until the user write at lest one character on textFiled for title on alert
    var addAction:UIAlertAction?
    
    //handel mode edit table view by using hold touch the table view and end it with press on done that will hidden when edit table view mode off
    @objc func addAnnotation(press:UILongPressGestureRecognizer) {
        tableView.isEditing=true
        doneButton.title="done"
        addButton.isEnabled=false
        dayModel = CoreDataBrain.fetchDayModel(tripId: tripModel!.tripID! as CVarArg)
    }
    
    //CoreData - save ddata from core data to use it and edit it
    var dayModel:[DayModels]?
    var activatyModel:[ActivityModel]?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.tintColor=Help.tintColor
        navigationItem.title=tripModel?.name
        //handel holde touch
        let pressHolder = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        pressHolder.minimumPressDuration=1.0
        tableView.addGestureRecognizer(pressHolder)
        
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
        activatyAction.isEnabled = self.tripModel?.dayModels?.count ?? 0 > 0
        
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
            
            //create new day
            let newDay = DayModels(context: CoreDataBrain.context)
            newDay.title=title.text!
            newDay.subTitle=subTitle.text!
            newDay.dayID=UUID()
            
            //save it in core data
            self.tripModel?.addToDayModels(newDay)
            CoreDataBrain.saveData()
            self.dayModel=CoreDataBrain.fetchDayModel(tripId: self.tripModel!.tripID! as CVarArg)
            //animated
            let indexSet = IndexSet(integer: self.tripModel!.dayModels!.count-1)
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
                //update
                self.dayModel = CoreDataBrain.fetchDayModel(tripId: self.tripModel!.tripID! as CVarArg)
                self.activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: popup.indexSelect, dayId: self.dayModel![popup.indexSelect].dayID! as CVarArg)
                //animated
                let indexPath = IndexPath(row: self.activatyModel!.count-1, section: popup.indexSelect)
                self.tableView.insertRows(at: [indexPath], with: .left)
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    //sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        dayModel = CoreDataBrain.fetchDayModel(tripId: tripModel!.tripID! as CVarArg)
        return tripModel?.dayModels?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Help.headerCell) as! HeaderTableViewCell
        cell.setup(dayModel: (dayModel![section]) )
        return cell.contentView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: section, dayId: dayModel![section].dayID! as CVarArg)
        return activatyModel?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Help.activatyCell) as! ActivatyTableViewCell
        activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: indexPath.section, dayId: dayModel![indexPath.section].dayID! as CVarArg)
        cell.setup(activatyModel: activatyModel![indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - Swipe Actions delete/edit
    //delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view,performAction: @escaping (Bool) -> Void) in
            //make alert to confirm delete from user
            self.activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: indexPath.section, dayId: self.dayModel![indexPath.section].dayID! as CVarArg)
            
            let alert = UIAlertController(title: "Delete Activaty", message: "are you sure you want delete \(self.activatyModel![indexPath.row].title!)", preferredStyle: .alert)
            
            //delete Action
            let deleteAction = UIAlertAction(title: "delete", style: .destructive) { action in
                self.dayModel![indexPath.section].removeFromActivityModel(self.activatyModel![indexPath.row])
                CoreDataBrain.saveData()
                self.activatyModel=CoreDataBrain.fetchActavatyModel(selectDay: indexPath.section, dayId: self.dayModel![indexPath.section].dayID! as CVarArg)
                
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
        activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: sourceIndexPath.section, dayId: dayModel![sourceIndexPath.section].dayID! as CVarArg)
        //we sort actavaty with tag so we just edit the tag only
        if sourceIndexPath.section == destinationIndexPath.section {
            let oldTag = sourceIndexPath.row
            let newTag = destinationIndexPath.row
            
            if oldTag > newTag{
                self.activatyModel![oldTag].activityTag=Int64(newTag)
                for item in newTag ..< oldTag {
                    self.activatyModel![item].activityTag+=1
                }
            }else if oldTag < newTag{
                self.activatyModel![oldTag].activityTag=Int64(newTag)
                for item in oldTag+1 ... newTag {
                    self.activatyModel![item].activityTag-=1
                }
            }
        }else{
            let actavity = self.activatyModel![sourceIndexPath.row]
            self.dayModel![sourceIndexPath.section].removeFromActivityModel(self.activatyModel![sourceIndexPath.row])
            self.activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: destinationIndexPath.section, dayId: dayModel![destinationIndexPath.section].dayID! as CVarArg)

            actavity.activityTag=Int64(destinationIndexPath.row)
            
            for item in destinationIndexPath.row ..< self.activatyModel!.count {
                self.activatyModel![item].activityTag+=1
            }
            self.dayModel![destinationIndexPath.section].addToActivityModel(actavity)
            
            
        }
        dayModel = CoreDataBrain.fetchDayModel(tripId: tripModel!.tripID! as CVarArg)
        activatyModel = CoreDataBrain.fetchActavatyModel(selectDay: destinationIndexPath.section, dayId: dayModel![destinationIndexPath.section].dayID! as CVarArg)

        CoreDataBrain.saveData()
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
