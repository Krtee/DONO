//
//  DonateTypeCollectionViewCell.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 23.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class DonateTypeCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .green
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
