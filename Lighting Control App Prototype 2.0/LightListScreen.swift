//
//  LightListScreen.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 9/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit

class LightListScreen: UIViewController {

    @IBOutlet weak var lightTableView: UITableView!
    var lightLabel: String?
    @IBOutlet weak var currentSession: UILabel!
    
    //uncomment the line below to reset data
    var light = ["Test Light 1", "Test Light 2", "Test Light 3"]
    //retrieving light list (comment it when resetting data)
    //var light = UserDefaults.standard.object(forKey: "Lights") as! [String]
    
    @IBAction func addButton(_ sender: Any) {
    }
    
    
    @IBAction func toFaceRecogButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the light list (uncomment it when resetting data)
        UserDefaults.standard.set(light, forKey: "Lights")
        //uncomment below to reset the pics. DO THIS BEFORE RESETTING THE LIGHT LIST
        //resetpic(lightarray: light)
        
        lightTableView.dataSource = self
        lightTableView.delegate = self
        lightTableView.reloadData()
        currentSession.text = "Current Session: \(dataClass.userID!)"

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLightSettingsSegue" {
            let nextPage = segue.destination as! lightSettings
            //setting the lightLabel at the destination page as the name of the light selected in the cell from this page
            nextPage.lightLabel = lightLabel
        }
        
    }
    
    func resetpic(lightarray: [String]) {
        for lights in lightarray {
            UserDefaults.standard.removeObject(forKey: lights)
        }
    }
    
    @IBAction func unwindToLightListScreen(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
}
    
extension LightListScreen: UITableViewDataSource, UITableViewDelegate {
    //function to determine the number of rows required in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return light.count
    }
    
    //function to create the cell at that particular row (indexpath contains the section and row number)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //to reuse cell that is out of view so that we dont have to constantly create new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LightTableViewCell
        
        //setting up the new cell. The row of the tableview corresponds to the index number of the light array
        if let imageData = UserDefaults.standard.object(forKey: light[indexPath.row]) as? Data {
            cell.setup(LightName: light[indexPath.row], LightImage: UIImage(data: imageData))
        }
        else {
            cell.setup(LightName: light[indexPath.row], LightImage: nil)
        }
        //return the cell to create it at the row in the tableview
        return cell
    }
    
    //delegate function to set the height of the row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    //what happens when u select a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //storing the light name as lightLabel to be sent to the destination segue
        lightLabel = light[indexPath.row]
        performSegue(withIdentifier: "toLightSettingsSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            let lightToBeDelete = self.light[indexPath.row]
            //removes the imaged saved
            UserDefaults.standard.removeObject(forKey: lightToBeDelete)
            //remove the light from the array
            self.light.remove(at: indexPath.row)
            //updating userdefaults with the new array
            UserDefaults.standard.set(self.light, forKey: "Lights")
            //updating the tableview
            tableView.deleteRows(at: [indexPath], with: .automatic)
            actionPerformed(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
