//
//  customTableViewCell.swift
//  therewhere
//
//  Created by Job van der Voort on 12/04/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell : UITableViewCell {
    @IBOutlet weak var meetupicon: UIImageView!
    @IBOutlet var meetupStatus: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    
    let baseColor: UIColor = UIColor(hex: "4A90E2")
    let inverseColor: UIColor = UIColor.whiteColor()
    
    var status: String = "idle"
    
    func loadItem(#friendProfile: FriendProfile) {
        fullNameLabel?.text = friendProfile.fullName
        meetupStatus.text = friendProfile.statusWithFriend
        self.status = friendProfile.statusWithFriend
        self.selectionStyle = UITableViewCellSelectionStyle.None
        styleCell(status, cell: self)
    }
    
    func updateMeetupStatus(status:String){
        meetupStatus.text = status
        self.status = status;
        styleCell(status, cell: self)
    }
    
    func sentMeetUp(){
        meetupicon.hidden = false
    }
    
    
    func styleCell(status: String, cell: CustomTableViewCell) {
        switch status {
        case "pending":
            // On pending, the cell should be slightly lighter
            cell.backgroundColor = self.baseColor.colorWithSaturationComponent(0.8)
            
        case "ready":
            // On ready, the cell should be default
            setDefaultStyle(cell)
            
        case "accepted":
            // On accepted, the cell should be inverse colored
            cell.backgroundColor = self.inverseColor
            cell.fullNameLabel?.textColor = self.baseColor
            
        case "waiting":
            // On waiting, the cell should blink
            makeCellBlink(cell)
            
        default:
            // By default, the cell should be default
            setDefaultStyle(cell)
        }
    }
    
    func setDefaultStyle(cell: CustomTableViewCell) {
        cell.backgroundColor = self.baseColor
        cell.fullNameLabel?.textColor = self.inverseColor
    }
    
    func makeCellBlink(cell: CustomTableViewCell) {
        
        let options =   UIViewAnimationOptions.Autoreverse |
            UIViewAnimationOptions.Repeat |
            UIViewAnimationOptions.CurveEaseInOut |
            UIViewAnimationOptions.AllowUserInteraction
        
        UIView.animateWithDuration(1.0, delay: 0, options: options, animations: {
            cell.backgroundColor = self.inverseColor
            cell.fullNameLabel?.textColor = self.baseColor
            }, completion: nil)
    }
    
}
