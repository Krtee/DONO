//
//  AppointmentTableViewCell.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 28.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hospitalname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
