//
//  LoginViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 14/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

import Foundation
import UIKit

class InviteFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet
    var tableView: UITableView!
    var items: [(FriendProfile)] = []
    
    var getFriendsTimer = NSTimer()
    var getOnGoingMeetupsTimer = NSTimer()
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        getFriendsTimer.invalidate()
    }
    
    @IBAction func logOutActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        

        let logoutAction = UIAlertAction(title: "Logout", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            var session = FBSession.activeSession()
            session.closeAndClearTokenInformation()
   
            var lgc = LoginViewController(nibName:"LoginViewController",bundle:nil)
            self.presentViewController(lgc, animated: false, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        
        })
        
        
        optionMenu.addAction(logoutAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        getFriendsTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateFriendsList", userInfo: nil, repeats: true)
        getFriendsTimer.fire()
        
        var userProfile = UserProfile.sharedInstance
        
        //Register for updating friends list notifications
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"handleGetFriendsNotification:",
            name: "getFriendsNotification",
            object: nil)
    }
    
    func updateFriendsList(){
        var user = User()
        
        user.getFriends()
    }
    
    func handleGetFriendsNotification(friendsObject: NSNotification){
        var friends = friendsObject.object as! [(FriendProfile)]
        
        //Clear outdated friends' list
        items.removeAll(keepCapacity: false)
        
        // Update list with new content
        for friend in friends{
            items.append(friend)
        }

        //Reload table with new data
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var customCellNib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        var shareCellNib = UINib(nibName: "ShareTableViewCell", bundle: nil)
        
        // Specify custom row/cell properties
        tableView.registerNib(customCellNib, forCellReuseIdentifier: "customCell")
        tableView.registerNib(shareCellNib, forCellReuseIdentifier: "shareCell")
        tableView.rowHeight = 110
        
        // Reload table with new data
        tableView.reloadData()
        
        tableView.addPullToRefreshWithAction {
            NSOperationQueue().addOperationWithBlock {
                sleep(1)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.refreshFriendsTableView()
                }
            }
        }
    }
    
    func refreshFriendsTableView()
    {
        var user = User()
        
        user.getFriends()
        self.tableView.stopPullToRefresh()
        MixpanelHandler.userPulledToRefresh()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = self.items.count+1
        return rowCount;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.row == self.items.count){
            var cell:ShareTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("shareCell") as! ShareTableViewCell
            return cell
        }else{
            var cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as! CustomTableViewCell
            
            if(!activityIndicator.hidden){
                activityIndicator.hidden = true
                activityIndicator.stopAnimating()
            }
            
            var friendProfile = items[indexPath.row]
            
            cell.loadItem(friendProfile: friendProfile)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if(indexPath.row == self.items.count){
            let alertController = UIAlertController(title: "Share the love!",
                message: "Invite your friends",
                preferredStyle: UIAlertControllerStyle.Alert)
            let shareHandler = { (action:UIAlertAction!) -> Void in
                MixpanelHandler.userSharedOnFacebook()
                
                var content = FBSDKShareLinkContent()
                content.contentURL = NSURL(string:"www.google.com")
                content.contentTitle = "google"
                content.contentDescription = "this is google #google"
                
                var dialog = FBSDKShareDialog()
                dialog.fromViewController = self
                dialog.shareContent = content
                dialog.mode = FBSDKShareDialogMode.ShareSheet
                dialog.show()
            }
            
            alertController.addAction(UIAlertAction(title: "Share", style: .Default, handler: shareHandler))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            var cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomTableViewCell
            var friendProfile = items[indexPath.row]
            
            cell.profileImage.animation = "pop"
            cell.profileImage.animate()
            
            switch cell.status {
                
            case "ready":
                // when cell status is "ready" a request meetup will be sent to selected friend
                var meetups = Meetups()
                var result = meetups.requestMeetup(String(friendProfile.friendID))
                
                cell.updateMeetupStatus("pending", friendProfile: friendProfile)
                
            case "accepted":
                // when cell status is "accepted" selecting this friend cell will open map with locations
                var controller = MapViewController(nibName:"MapViewController", bundle:nil)
                var friend = FriendProfile()
                
                controller.setFriend(friendProfile)
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            case "pending":
                // when cell status is "pending" it means a request was already sent and you need to wait for the result
                let alertController = UIAlertController(title: "Meetup!",
                    message: "Your friend was already notified :)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelActionHandler = { (action:UIAlertAction!) -> Void in
                    var friend_id:NSNumber = friendProfile.friendID as NSNumber!
                    var meetup = Meetups()
                    meetup.cancelMeetup(toString(friend_id))
                    
                    cell.updateMeetupStatus("ready", friendProfile: friendProfile)
                }
                
                alertController.addAction(UIAlertAction(title: "Cancel Request", style: .Default, handler: cancelActionHandler))
                alertController.addAction(UIAlertAction(title: "I'll wait", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            case "waiting":
                // when cell status is "waiting" it means a friend sent you a request and you haven't responded yet
                var friend = self.items[indexPath.row] as FriendProfile
                var msg = "\(friend.fullName) wants to meet!"
                let alert = UIAlertController(title: "Meetup Request", message: msg, preferredStyle: .Alert)
                
                let acceptActionHandler = { (action:UIAlertAction!) -> Void in
                    var friend_id:NSNumber = friendProfile.friendID as NSNumber!
                    var meetup = Meetups()
                    meetup.acceptMeetup(toString(friend_id))
                    cell.updateMeetupStatus("accepted", friendProfile: friendProfile)
                }
                
                let declineActionHandler = { (action:UIAlertAction!) -> Void in
                    var friend_id:NSNumber = friendProfile.friendID as NSNumber!
                    var meetup = Meetups()
                    meetup.declineToMeetup(toString(friend_id))
                    cell.updateMeetupStatus("ready", friendProfile: friendProfile)
                }
                
                alert.addAction(UIAlertAction(title: "Accept", style: .Default, handler: acceptActionHandler))
                alert.addAction(UIAlertAction(title: "Decline", style: .Destructive, handler: declineActionHandler))
                alert.addAction(UIAlertAction(title: "Delay", style: .Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            default:
                //when there's no status defer to default
                let alertController = UIAlertController(title: "Hey!",
                    message: "Nothing to do :)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Move Along", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}