//
//  AddCourseworkVC2.swift
//  native3.0
//
//  Created by Mark O'Grady on 07/05/2016.
//  Copyright © 2016 Mark O'Grady. All rights reserved.
//

import UIKit
import CoreData

class AddCourseworkVC2: UIViewController {
    var data = ["iPad", "iPhone", "iWatch", "iPod", "iMac"]
    var buttonData = ["US","China","London","Canada","Japan"];
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count
    }
    

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as UITableViewCell
        
        var label = UILabel(frame: CGRectMake(280.0, 14.0, 100.0, 30.0))
        label.text = data[indexPath.row]
        label.tag = 1
        cell.contentView.addSubview(label)
        
        
       let btn = UIButton(type: UIButtonType.System)
        btn.backgroundColor = UIColor.greenColor()
        btn.setTitle(buttonData[indexPath.row], forState: UIControlState.Normal)
        btn.frame = CGRectMake(0, 5, 80, 40)
        btn.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = indexPath.row
        cell.contentView.addSubview(btn)
        
        return cell
    }
    
    //Button Action is
    func buttonPressed(sender:UIButton!)
    {
        let buttonRow = sender.tag
        print("button is Pressed")
        print("Clicked Button Row is",buttonRow)
    }
}

