//
//  LoginViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 14/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell : UITableViewCell {
    @IBOutlet weak var meetupicon: UIImageView!
    @IBOutlet var meetupStatus: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    
    var status: String = "idle"
    
    func loadItem(#fullName: String, id: Int, status: String) {
        fullNameLabel?.text = fullName
        meetupStatus.text = status
        self.status = status
    }
    
    func updateMeetupStatus(status:String){
        meetupStatus.text = status
        self.status = status;
    }
    
    func sentMeetUp(){
        meetupicon.hidden = false
    }
}

class InviteFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet
    var tableView: UITableView!
    var items: [(String, Int, String, String)] = []
    var friendArray:[(String,Int, String)] = []
    var colorArray = [UIColor(hex: "CB1E62"), UIColor(hex: "27BF59"), UIColor(hex: "7B24BF"), UIColor(hex: "E59F1D"), UIColor(hex: "50E3C2")]
    
    @IBAction func backButton(sender: AnyObject) {
        let loginViewController = LoginViewController(nibName:"LoginViewController",bundle:nil)
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        var userProfile = UserProfile.sharedInstance
        var user = User()
        
        var meetups = Meetups()
        
        //Register for updating friends list notifications
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"handleGetFriendsNotification:",
            name: "getFriendsNotification",
            object: nil)

        meetups.getPendingMeetups()
        
        //Update list of friends
        user.getFriends()
        
        
    }
    
    func handleGetFriendsNotification(friends: NSNotification){

        var friends = friends.object as Friends
        
        //Clear outdated friends' list
        items.removeAll(keepCapacity: false)

        //Update list with new content
        for (name, id, status, phoneNumber) in friends.phoneNumberArray{
            items.append(name, id, status, phoneNumber)
        }
        
        //Reload table with new data
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        //Specify custom row/cell properties
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 60
        
        //Reload table with new data
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //Use custom cell
        var cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as CustomTableViewCell
        
        // this is how you extract values from a tuple
        var (fullName, id, status, phoneNumber) = items[indexPath.row]
        
        cell.contentView.backgroundColor = getRandomColor(countElements(fullName))
        cell.loadItem(fullName: fullName, id: id, status: status)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var (title, id, status, phoneNumber) = items[indexPath.row]
        var cell = tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell

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
            
            controller.setColor(getRandomColor(countElements(title)))
            controller.setFriendProfile(friend)
            
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
    
    // Explicitly update friends list
    @IBAction func refreshButton(sender: AnyObject) {
        var user = User()
        
        user.getFriends()
        tableView.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func getRandomColor(nameSize: Int) -> UIColor{
        
        if(nameSize < colorArray.count){
            return colorArray[nameSize]
        }
        else{
            return getRandomColor(nameSize-colorArray.count)
        }
    }
    
}