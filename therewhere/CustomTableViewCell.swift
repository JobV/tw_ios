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
    @IBOutlet var fullNameLabel: SpringLabel!
    @IBOutlet var profileImage: SpringImageView!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    let baseColor: UIColor = UIColor(hex: "4A90E2")
    let inverseColor: UIColor = UIColor.whiteColor()
    
    var status: String = "idle"
    
    func loadItem(#friendProfile: FriendProfile) {
        fullNameLabel?.text = friendProfile.fullName
        let cache = Shared.dataCache
        
        // Get Profile Image from cache
        cache.fetch(key: friendProfile.providerID as String)
            .onSuccess { data in
                var profile = UIImage(data: data)!
                self.profileImage.image = profile
                self.profileImage.frame = CGRectMake(0, 0, 50, 50);
                self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
                self.profileImage.layer.masksToBounds = true;
        }
        
        // Get cover image from cache
        cache.fetch(key: "\(friendProfile.providerID)_cover_image" as String)
            .onSuccess { data in
                var coverImage = UIImage(data: data)!
                self.coverImage.image = coverImage
        }
        
        self.status = friendProfile.statusWithFriend
        self.selectionStyle = UITableViewCellSelectionStyle.None
        styleCell(status, cell: self, friendProfile: friendProfile)
    }
    
    func updateMeetupStatus(status: String, friendProfile: FriendProfile){
        self.status = status;
        styleCell(status, cell: self, friendProfile: friendProfile)
    }
    
    func sentMeetUp(){
    }
    
    
    func styleCell(status: String, cell: CustomTableViewCell, friendProfile: FriendProfile) {
        switch status {
        case "pending":
            self.fullNameLabel.text = "waiting for answer.."

        case "ready":
            self.fullNameLabel.text = friendProfile.fullName
            
        case "accepted":
            self.fullNameLabel.text = "Location available!"

        case "waiting":
            UIView.animateWithDuration(1, animations: {
                self.blurView.alpha = 0.7;
            })
 
        default:
            self.fullNameLabel.text = friendProfile.fullName
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
