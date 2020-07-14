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
    
    //Context wo sich die Daten/Objekte befinden
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Ein Array zum zwischenspeichern der Daten/Objekte aus dem Context
    var hospital = [Hospitals]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
        //return hospital.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath)
        //let hospitalArray = hospital[indexPath.row]
        
        cell.textLabel?.text = "Test"
        //cell.textLavel?.text = Hospitals[indexPath.row]

        return cell
    }
    
    
    
    func createHospitalTestData() {
        createHospital(hospitalID: "9189248", name: "Marien Hospital", coordinates: "981.241.122.456", street: "Stuttgarter Straße 111", postCode: 70569)
        
        print("Krankenhaus erstellt")
    }
    func loadHospitalTestData() {
        if let hospitalArray = loadData() {
            self.hospital = hospitalArray
            print("Hospital Test Data wurde geladen")
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Sektion:  \(indexPath.section)")
        print("Zeile:  \(indexPath.row)")
            
            let row = indexPath.row
    }

    //Daten einfügen/User Object erstellen
    func createHospital(hospitalID: String, name: String, coordinates: String, street: String, postCode: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "Hospitals", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(hospitalID, forKey: "hospitalID")
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(coordinates, forKey: "coordinates")
        managedObject.setValue(street, forKey: "street")
        managedObject.setValue(postCode, forKey: "postCode")
        
        saveContext()
    }
    
    //Daten laden -> Erhalten einen Array zurück
    func loadData() -> [Hospitals]? {
        let fetchRequest: NSFetchRequest<Hospitals> = Hospitals.fetchRequest() //Anfrage
        
        do {
            let resultArray = try context.fetch(fetchRequest) //Daten holen
            return resultArray
        } catch  {
            print(error.localizedDescription)
        }
        return nil
    }
    
    //Speichern/Immer aufrufen sobald sich im context etwas veränderts
    func  saveContext() {
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
