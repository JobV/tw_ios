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
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet weak var meetupicon: UIImageView!
    @IBOutlet var meetupStatus: UILabel!
    var status: String = "idle"
    
    func loadItem(#title: String, id: Int, status: String) {
        titleLabel?.text = title
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
    
    var items: [(String, Int, String)] = []
    var friendArray:[(String,Int, String)] = []
    var colorArray = [UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(),UIColor.darkGrayColor(), UIColor.grayColor(),UIColor.greenColor(), UIColor.lightGrayColor(), UIColor.magentaColor(), UIColor.orangeColor(),UIColor.purpleColor(),UIColor.redColor(),UIColor.whiteColor(), UIColor.yellowColor()]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notification:", name:"meetup", object: nil)
        navigationController?.navigationBarHidden = true;

        var userProfile = UserProfile.sharedInstance
        userProfile.userID = "1"

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"handleGetFriendsNotification:",
            name: "getFriendsNotification",
            object: nil)

        var user = User()
        user.getFriends()
        tableView.reloadData()
        
    }
    func handleGetFriendsNotification( note: NSNotification){
        var friends = note.object as Friends
        println("starting update")
        items.removeAll(keepCapacity: false)
        for (name, id, status) in friends.phoneNumberArray{
            items.append(name, id, status)
            println(name)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true;
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 60
    }
    
    func notification(userInfo: NSDictionary){
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as CustomTableViewCell
        
        // this is how you extract values from a tuple
        var (title, id, status) = items[indexPath.row]
        
        cell.contentView.backgroundColor = getRandomColor(countElements(title))
        cell.loadItem(title: title, id: id, status: status)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var (title, id, status) = items[indexPath.row]
        
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell
        println("cell status: \(cell.status)")
        switch cell.status {
            case "ready":
                var meetups = Meetups()
                var result = meetups.requestMeetup(String(self.items[indexPath.row].1))
                cell.updateMeetupStatus("pending")
            case "accepted":
                var controller = MapViewController(nibName:"MapViewController",bundle:nil)
                controller.setColor(getRandomColor(countElements(title)))
                controller.setFriendID(self.items[indexPath.row].1)
                navigationController?.pushViewController(controller, animated: true)
            case "pending":
                let alertController = UIAlertController(title: "Meetup!",
                    message: "Your friend was already notified, just wait :)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Move Along", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            case "waitingYourReply":
                cell.updateMeetupStatus("inmeetup")
            default:
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
    
    func getRandomColor(nameSize: Int) -> UIColor{
        
        if(nameSize < colorArray.count){
            return colorArray[nameSize]
        }
        else{
            return getRandomColor(nameSize-colorArray.count)
        }
    }

}