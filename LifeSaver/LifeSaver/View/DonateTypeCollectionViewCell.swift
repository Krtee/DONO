//
//  DonateTypeCollectionViewCell.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 23.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class DonateTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var donatypeName: UILabel!
    
    @IBOutlet weak var donatePic: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
