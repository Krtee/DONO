//
//  timeCollectionViewCell.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 03.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var time: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor.blue : UIColor.white
        }
      }
}
