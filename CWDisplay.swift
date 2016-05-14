//
//  CWDisplay.swift
//  native3.0
//
//  Created by Mark O'Grady on 13/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import UIKit

class CWDisplay: UITableViewCell {

    @IBOutlet weak var moduleNameLbl: UILabel!
    @IBOutlet weak var logoLbl: UILabel!
    @IBOutlet weak var courseworkNameLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
