//
//  dueDateView.swift
//  native3.0
//
//  Created by Mark O'Grady on 16/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import UIKit

class dueDateView: UIView {

    var helper:Helper!

    func getColor(color:String) -> UIColor {
        helper = Helper()
        return helper.hexStringToUIColor(color)
    }
    
    var lineWidth:CGFloat = 3 { didSet { setNeedsDisplay() } }
    var color:UIColor = UIColor.darkGrayColor() { didSet { setNeedsDisplay() } }
    var color2:UIColor = UIColor.redColor() { didSet { setNeedsDisplay() } }

    var circCenter:CGPoint {
        return convertPoint(center, fromCoordinateSpace: superview!)
    }
    
    var circRadius:CGFloat {
        return min(bounds.size.width-20, bounds.size.height-20)/2
    }
    override func drawRect(rect: CGRect) {
        let circPath = UIBezierPath(arcCenter: circCenter, radius: circRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
//        self.layer.borderColor = UIColor.whiteColor().CGColor
//        self.layer.cornerRadius = 5
//        
//        self.layer.borderWidth = 3.0;
        
        circPath.lineWidth = 13
        color.set()
        circPath.stroke()
        
        let circPath2 = UIBezierPath(arcCenter: circCenter, radius: circRadius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(2 * M_PI-305), clockwise: true)
        
        circPath2.lineWidth = 13
        helper = Helper()
        color2 = helper.hexStringToUIColor("F54646")
        color2.set()
        circPath2.stroke()

    }
}
