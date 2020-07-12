//
//  homeCollectionViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 23.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DonateTypeCell"

class homeCollectionViewController: UICollectionViewController {
    
    @IBOutlet var collectionview: UICollectionView! 
    
    let flowLayout = ZoomAndSnapFlowLayout()
    var items = ["1", "2", "3"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        title = "Zoomed & snapped cells"
        
        collectionView.collectionViewLayout = flowLayout
        

        //guard let collectionView = collectionView else { fatalError() }
        //collectionView.decelerationRate = .fast // uncomment if necessary
        //collectionview.collectionViewLayout = flowLayout
        //collectionView.contentInsetAdjustmentBehavior = .always

        // Register cell classes
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DonateTypeCell", for: indexPath) as! DonateTypeCollectionViewCell
        
        cell.backgroundColor = UIColor.cyan
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.green
        cell.selectedBackgroundView = backgroundView// make cell more visible in our example project
        
        return cell
        // Configure the cell
    
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
