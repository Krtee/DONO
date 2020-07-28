//
//  AppointmentViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 28.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var appointmentTableView: UITableView!
    
    var allappointments: [Appointment]?
    var chosenAppointment: Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allappointments = CoreDataAppointmentService.defaults.loadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allappointments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentTableViewCell
        
        cell.hospitalname.text = allappointments?[indexPath.row].hospital?.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, dd.MM.yyyy"

        cell.date.text = formatter.string(for: allappointments?[indexPath.row].date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenAppointment = allappointments?[indexPath.row]
        
        performSegue(withIdentifier: "toQRCode", sender: chosenAppointment)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQRCode" {
            print(chosenAppointment)
            
            if let vc = segue.destination as? QRCodeGenerator {

                vc.fetchedAppointment = chosenAppointment

            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
