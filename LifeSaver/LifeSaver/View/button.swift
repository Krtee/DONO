

import Foundation
import UIKit

class MyButton: UIView{
    
    private var shadowLayer: CAShapeLayer!
    private var gradient: CAGradientLayer?
    
    
    
    // initializers
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      installGradient()
    }
    override init(frame: CGRect) {
      super.init(frame: frame)
      installGradient()
    }
    
    
    private func createGradient() -> CAGradientLayer {
      let gradient = CAGradientLayer()
      gradient.frame = self.bounds
      return gradient
    }
    
    
    private func installGradient() {
      // if there's already a gradient installed on the layer, remove it
      if let gradient = self.gradient {
        gradient.removeFromSuperlayer()
      }
      let gradient = createGradient()
      self.layer.insertSublayer(gradient, at: 0)
      self.gradient = gradient
    }
    
    override var frame: CGRect {
      didSet {
        updateGradient()
      }
    }
    
    private func updateGradient() {
        if let gradient = self.gradient {
            let colorLeft =  UIColor(red: 32.0/255.0, green: 33.0/255.0, blue: 34.0/255.0, alpha: 1.0).cgColor
            let colorRight = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor

            gradient.colors = [colorLeft, colorRight]
            gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 2*3, 0, 0, 1)
            gradient.locations = [0.0, 1.0]
            gradient.frame = self.bounds
            
            gradient.cornerRadius = 12

        }
    }


    override func didMoveToWindow() {
        self.layer.masksToBounds = false
        setCornersAndShadows()


        //setGradientBackground()


    }
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        updateGradient()

    }
    
    
    func setCornersAndShadows(){
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        self.backgroundColor = UIColor.clear
    }
    
    /*func setGradientBackground() {
        let colorLeft =  UIColor(red: 247.0/255.0, green: 205.0/255.0, blue: 179.0/255.0, alpha: 1.0).cgColor
        let colorRight = UIColor(red: 245.0/255.0, green: 188.0/255.0, blue: 199.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2*3, 0, 0, 1)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 12

        self.layer.insertSublayer(gradientLayer, at:0)
    }*/
}
