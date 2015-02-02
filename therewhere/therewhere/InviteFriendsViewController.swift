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
    
    func loadItem(#title: String, image: String) {
//        backgroundImage?.image = UIImage(named: "Logo Pin" )
        titleLabel?.text = title
    }
}

class InviteFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet
    var tableView: UITableView!
    
    var items: [(String, String)] = []
    var friendArray:[(String,Int)] = []
    
    @IBAction func next(sender: AnyObject) {
        var controller = MainMapViewController(nibName:"MainMapViewController", bundle:nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"handleGetFriendsNotification:",
            name: "getFriendsNotification",
            object: nil)

        var user = User()
        user.getFriends()
        
    }
    func handleGetFriendsNotification( note: NSNotification){
        var friends = note.object as Friends
        println("starting update")
        items.removeAll(keepCapacity: false)
        for (name, id) in friends.phoneNumberArray{
            items.append(name, "Logo Pin")
            println(name)
        }
        tableView.reloadData()
        println("updated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true;
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 44
//        nextButton.frame = CGRectMake(245.0, 60, 65, 65)
        nextButton.layer.cornerRadius = nextButton.frame.size.width / 2
        nextButton.layer.shadowRadius = 3.0
        nextButton.layer.shadowColor = UIColor.blackColor().CGColor
        nextButton.layer.shadowOffset = CGSizeMake(0,1.0)
        nextButton.layer.shadowOpacity = 0.5
        nextButton.layer.masksToBounds = false
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as CustomTableViewCell
        
        // this is how you extract values from a tuple
        var (title, image) = items[indexPath.row]
        
        cell.loadItem(title: title, image: image)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("You selected cell #\(indexPath.row)!")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}