//
//  CWDisplay.swift
//  native3.0
//
//  Created by Mark O'Grady on 13/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import UIKit
import Foundation

class TaskDisplayTableViewCell: UITableViewCell {
    var helper:Helper!
    @IBOutlet weak var logoLbl: UILabel!
    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var taskDueDateLbl: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        helper = Helper()
        let c = helper.hexStringToUIColor("#D1D1D1")
        self.logoLbl.layer.borderWidth = 1
        self.logoLbl.layer.borderColor = c.CGColor
        self.logoLbl.layer.cornerRadius = 27
        self.logoLbl.font = UIFont(name: "system", size:55)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
