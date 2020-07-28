//
//  QRCodeGenerator.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 26.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications


class QRCodeGenerator: UIViewController {
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var saveQRCodeButton: UIButton!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var appointmentDate: UILabel!
    
    
    var notifications = NotificationDelegate()

    var fetchedAppointment: Appointment?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveQRCodeButton.isEnabled = true
                
        hospitalName.text = fetchedAppointment?.hospital?.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, dd.MM.yyyy"

        appointmentDate.text = formatter.string(from: (fetchedAppointment?.date)!)

        _ = createQRCode()
        
    }
    
    
    func createQRCode() -> Bool {
        let userID = UserDefaults.standard.string(forKey: "userID")
        let fetchedUser = CoreDataUserService.defaults.loadfromID(id : userID!)
        
            if fetchedAppointment != nil && fetchedUser != nil{
                let jsondata = convertToJSONArray(item: fetchedUser!)
                let data = jsondata.data(using: .ascii, allowLossyConversion: false)
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(data, forKey: "InputMessage")
                let ciImage = filter?.outputImage
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let transformImage = ciImage?.transformed(by: transform)
                let image = UIImage(ciImage: transformImage!)
                qrImageView.image = image
                return true
            }
            else {
                print("could not fetch appointment")
                return false
            }
            
    }
    
    func convertToJSONArray(item: NSManagedObject) -> String {
        var dict: [String: Any] = [:]
        for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
            if let value = item.value(forKey: attribute.key) {
                if attribute.key != "password"{
                    dict[attribute.key] = value
                }
            }
        }
        print(dict.description)
        return dict.description
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set("",forKey: "AppointmentID")
    }
    
    
    @IBAction func saveQRCodeButtonPressed(_ sender: Any) {
        screenShotMethod()
    }
    
    //when we want to save the image of the qr code
    func screenShotMethod() {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
    }
}
