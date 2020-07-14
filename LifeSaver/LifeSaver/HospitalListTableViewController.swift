//
//  HospitalListTableViewController.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 14.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit
import CoreData

class HospitalListTableViewController: UITableViewController {

    @IBOutlet weak var hospitalListTableView: UITableView!
    
    var selectedHospital: Hospitals?
    
    //Context wo sich die Daten/Objekte befinden
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var hospitalListArray = [Hospitals]()
    //Ein Array zum zwischenspeichern der Daten/Objekte aus dem Context
    var hospital = [Hospitals]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hospitalListTableView.delegate = self
        hospitalListTableView.dataSource = self
        hospitalListTableView.rowHeight = 80
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()
    }

    
    //MARK: - Action Buttons
    @IBAction func createButton_Tapped(_sender: UIBarButtonItem) {
        createHospital()
    }
    
    @IBAction func refreshButton_Tapped(_sender: UIBarButtonItem) {
        loadData()
    }
    
    
    //MARK: - Methoden
    func createHospital() {
        let alert = UIAlertController(title: "Add Hospital", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "HospitalID"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Street"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "PostCode"
            textField.keyboardType = .numberPad
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "coordinates"
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            if alert.textFields?[0].text?.count != 0
                && alert.textFields?[1].text?.count != 0
                && alert.textFields?[2].text?.count != 0
                && alert.textFields?[3].text?.count != 0
                && alert.textFields?[4].text?.count != 0 {
                let hospitalID = alert.textFields?[0].text
                let name = alert.textFields?[1].text
                let street = alert.textFields?[2].text
                let postCode = Int64((alert.textFields?[3].text)!)
                let coordinates = alert.textFields?[4].text
                
                //Core Data
                let hospitalInformation = CoreDataService.defaults.createHospital(_hospitalID: hospitalID!, _name: name!, _coordinates: coordinates!, _street: street!, _postCode: postCode!)
                
                //Array
                self.hospitalListArray.append(hospitalInformation)
                self.hospitalListTableView.reloadData()
                
            } else {
                self.errorMessage(_message: "Bitte Daten eingeben")
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Daten laden -> Erhalten einen Array zurück
    func loadData() {
        let hospitalListArray = CoreDataService.defaults.loadData()
        
        if let _hospitalListArray = hospitalListArray {
            self.hospitalListArray = _hospitalListArray
            self.hospitalListTableView.reloadData()
        }
    }
    
    func errorMessage(_message: String) {
        let alert = UIAlertController(title: "Fehler", message: _message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // goToShowUserInformationSegue
        if segue.identifier == "goToHospitalDetailsSegue" {
            let destVC = segue.destination as! HospitalListTableViewController
            destVC.hospital = selectedHospital
        }
    }*/
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
        //return hospitalArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath)

        //let hospitalArray = hospital[indexPath.row]
        cell.textLabel?.text = "Test"
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Sektion:  \(indexPath.section)")
        print("Zeile:  \(indexPath.row)")
         
        //selectedHospital = hospitalListArray[indexPath.row]
        //performSegue(withIdentifier: "goToHospitalDetailsSegue", sender: nil)
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }

}
