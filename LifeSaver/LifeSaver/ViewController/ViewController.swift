//
//  ViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 21.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentview: UIView!
    @IBAction func switchToLogin(_ sender: Any) {
        if currentViewControllerIndex != 0 {
        currentViewControllerIndex = 0
            pageViewController?.setViewControllers([detailViewControllerAt(index: 0)] as? [UIViewController], direction: .reverse, animated: true)
        }

    }
    @IBAction func switchToRegister(_ sender: Any) {
        if currentViewControllerIndex != 1 {
        currentViewControllerIndex = 1
            pageViewController!.setViewControllers([detailViewControllerAt(index: 1)] as? [UIViewController], direction: .forward, animated: true)
        }

        
    }
    
    let dataSource = ["Viewcontroller one","Viewcontroller two"]
    
    var currentViewControllerIndex = 0
    
    var pageViewController: LandingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        configurePageViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userID: String? = UserDefaults.standard.string(forKey: "userID")
        print("\(String(describing: userID))")
              
        if userID != nil  && userID !=  "" {
                  self.performSegue(withIdentifier: "shortcutsegue", sender: self)
              }
    }
    
     
    func configurePageViewController() {
        pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: LandingPageViewController.self)) as? LandingPageViewController
        
        if pageViewController != nil {
        
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        
        addChild(pageViewController!)
        pageViewController?.didMove(toParent: self)
        
        pageViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentview.addSubview((pageViewController?.view)!)
        
        let views: [String: Any] = ["pageView": pageViewController!.view!]
        
        contentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views))
        
        contentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views))
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            print("error2")
            return
        }
        
        pageViewController?.setViewControllers([startingViewController], direction: .forward, animated: true)
            
        }
    }
    
    func detailViewControllerAt(index: Int) -> UIViewController? {
        
        if index >= dataSource.count || dataSource.count == 0 {
            return nil
        }
        
        if index == 0{
            guard let dataViewController = storyboard? .instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as? LoginViewController else {
                       print("error3")
                       return nil
                   }
                   
                   dataViewController.index = index
                   dataViewController.displayText = dataSource[index]
                   
                   return dataViewController
                   
        } else{
            guard let dataViewController = storyboard? .instantiateViewController(withIdentifier: String(describing: RegisterViewController.self)) as? RegisterViewController else {
                print("error3")
                return nil
            }
                              
            dataViewController.index = index
            //dataViewController.displayText = dataSource[index]
                              
            return dataViewController
        }
    }
}

extension ViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource{

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let dataViewController = viewController as? LoginViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let dataViewController = viewController as? LoginViewController
        
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        if currentIndex == dataSource.count{
            return nil
        }
        
        currentIndex += 1
        
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }
}
