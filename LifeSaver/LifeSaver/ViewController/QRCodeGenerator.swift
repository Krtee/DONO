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

class QRCodeGenerator: UIViewController {
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrTextField: UITextField!
    @IBOutlet weak var generateQRButton: UIButton!
    @IBOutlet weak var saveQRCodeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveQRCodeButton.isEnabled = false
        
        let defaults = UserDefaults.standard
        let id: String? = defaults.string(forKey: "AppointmentID")

        createQRCode(appointmentID: id ?? "no id")
    }
        //Button 1
    @IBAction func generateQRCodeButtonPressed(_ sender: Any) {
        print("generateQRCodeButton is pressed")
        
        if let myString = qrTextField.text {
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "InputMessage")
            let ciImage = filter?.outputImage
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            
            let image = UIImage(ciImage: transformImage!)
            qrImageView.image = image
            
            saveQRCodeButton.isEnabled = true
        }

    }
    
    func createQRCode(appointmentID: String) -> Bool {
        let context = CoreDataService.defaults.persistentContainer.viewContext
        
        let requestAppointment = NSFetchRequest<NSFetchRequestResult>(entityName: "Appointment")
               let predicate = NSPredicate(format: "userID == %@", appointmentID)
               requestAppointment.predicate = predicate
        
        do{
            let resultsAppointments = try context.fetch(requestAppointment)
            
            var fetchedAppointment: NSManagedObject?
             
            for r in resultsAppointments {
                if let result = r as? NSManagedObject {
                    
                    let jsondata = convertToJSONArray(item: result)
                   let data = jsondata.data(using: .ascii, allowLossyConversion: false)
                              let filter = CIFilter(name: "CIQRCodeGenerator")
                              filter?.setValue(data, forKey: "InputMessage")
                              let ciImage = filter?.outputImage
                              let transform = CGAffineTransform(scaleX: 10, y: 10)
                              let transformImage = ciImage?.transformed(by: transform)
                              
                              let image = UIImage(ciImage: transformImage!)
                              qrImageView.image = image
                }
            }
            return true
            
        } catch let err {
            print(err)
            return false
        }
    }
    
    func convertToJSONArray(item: NSManagedObject) -> String {
        var jsonArray: [[String: Any]] = []
        var dict: [String: Any] = [:]
        for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
            if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
            }
            jsonArray.append(dict)
        }
        return jsonArray[0].description
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
