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
    var items: [(String, Int, String, String)] = []
    var friendArray:[(String,Int, String)] = []
    var colorArray = [UIColor(hex: "CB1E62"), UIColor(hex: "27BF59"), UIColor(hex: "7B24BF"), UIColor(hex: "E59F1D"), UIColor(hex: "50E3C2")]
    var getFriendsTimer = NSTimer()
    var getOnGoingMeetupsTimer = NSTimer()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        getFriendsTimer.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
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
        var friends = friendsObject.object as! Friends
        
        //Clear outdated friends' list
        items.removeAll(keepCapacity: false)

        // Update list with new content
        for (name, id, status, phoneNumber) in friends.phoneNumberArray{
            items.append(name, id, status, phoneNumber)
        }
        
        for _ in 1...9 {
            items.append("John Doe", 1123, "pending", "12312323")
        }

        
        //Reload table with new data
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load multitouch
        let twoFingerTap = UITapGestureRecognizer(target: self, action: "twoFingerTap")
        twoFingerTap.numberOfTapsRequired = 1
        twoFingerTap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(twoFingerTap)
        
        let threeFingerTap = UITapGestureRecognizer(target: self, action: "threeFingerTap")
        threeFingerTap.numberOfTouchesRequired = 1
        threeFingerTap.numberOfTouchesRequired = 3
        view.addGestureRecognizer(threeFingerTap)
        twoFingerTap.requireGestureRecognizerToFail(threeFingerTap)
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        //Specify custom row/cell properties
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 60
        
        //Reload table with new data
        tableView.reloadData()
    }
    
    // Go back when tapping with two fingers
    func twoFingerTap() {
        println("Two finger tap detected. Going back.")
        let loginViewController = LoginViewController(nibName:"LoginViewController",bundle:nil)
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    // Refresh when tapping with three fingers
    func threeFingerTap() {
        println("Three finger tap detected. Refreshing.")
        var user = User()
        user.getFriends()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Use custom cell
        var cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as! CustomTableViewCell
        
        // this is how you extract values from a tuple
        var (fullName, id, status, phoneNumber) = items[indexPath.row]
        
//        cell.contentView.backgroundColor = getRandomColor(countElements(fullName))
        cell.loadItem(fullName: fullName, id: id, status: status)
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var (title, id, status, phoneNumber) = items[indexPath.row]
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomTableViewCell
        
        switch cell.status {
            
        case "ready":
            // when cell status is "ready" a request meetup will be sent to selected friend
            var meetups = Meetups()
            var result = meetups.requestMeetup(String(self.items[indexPath.row].1))
            
            cell.updateMeetupStatus("pending")
            
        case "accepted":
            // when cell status is "accepted" selecting this friend cell will open map with locations
            var controller = MapViewController(nibName:"MapViewController", bundle:nil)
            var friend = FriendProfile()
            
            friend.friendID = self.items[indexPath.row].1
            friend.firstName = self.items[indexPath.row].0
            friend.phoneNumber = self.items[indexPath.row].3
            
            controller.setColor(UIColor.greenColor())
            controller.setFriend(friend)
            
            self.presentViewController(controller, animated: true, completion: nil)
            
        case "pending":
            // when cell status is "pending" it means a request was already sent and you need to wait for the result
            let alertController = UIAlertController(title: "Meetup!",
                message: "Your friend was already notified, just wait :)",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Move Along", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        case "waiting":
            // when cell status is "waiting" it means a friend sent you a request and you haven't responded yet
            var msg = "\(self.items[indexPath.row].0) wants to meet!"
            let alert = UIAlertController(title: "Meetup Request", message: msg, preferredStyle: .Alert)
            
            let acceptActionHandler = { (action:UIAlertAction!) -> Void in
                var friend_id:NSNumber = self.items[indexPath.row].1 as NSNumber!
                var meetup = Meetups()
                meetup.acceptMeetup(toString(friend_id))
                cell.updateMeetupStatus("accepted")
            }
            
            let declineActionHandler = { (action:UIAlertAction!) -> Void in
                var friend_id:NSNumber = self.items[indexPath.row].1 as NSNumber!
                var meetup = Meetups()
                meetup.declineToMeetup(toString(friend_id))
                cell.updateMeetupStatus("ready")
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
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    func colorForIndex(index: Int) -> UIColor {
        let itemsCount = items.count - 1
        let colorVal = (CGFloat(index) / CGFloat(itemsCount)) * 0.6
        return UIColor(red: 1.0, green: colorVal, blue: 0.0, alpha: 1.0)
    }

}