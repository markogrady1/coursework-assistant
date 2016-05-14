//
//  CWDisplay.swift
//  native3.0
//
//  Created by Mark O'Grady on 13/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import UIKit
import Foundation

class CWDisplayTableViewCell: UITableViewCell {
    var helper:Helper!
    var bgColor:String!
    @IBOutlet weak var moduleNameLbl: UILabel!
    @IBOutlet weak var logoLbl: UILabel!
    @IBOutlet weak var courseworkNameLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    
    override func awakeFromNib() {
    super.awakeFromNib()
        helper = Helper()
        let c = helper.hexStringToUIColor("#D1D1D1")
        self.logoLbl.layer.borderWidth = 1
        self.logoLbl.layer.borderColor = c.CGColor
        self.logoLbl.layer.cornerRadius = 43
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
