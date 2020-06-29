//
//  QRCodeGenerator.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 26.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import UIKit

class QRCodeGenerator: UIViewController {
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrTextField: UITextField!
    @IBOutlet weak var generateQRButton: UIButton!
    @IBOutlet weak var saveQRCodeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveQRCodeButton.isEnabled = false
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
