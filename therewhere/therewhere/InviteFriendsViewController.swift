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
    @IBOutlet var backgroundImage: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    
    func loadItem(#title: String, image: String) {
        backgroundImage?.image = UIImage(named: "Logo Pin" )
        titleLabel?.text = title
    }
}

class InviteFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet
    var tableView: UITableView!
    //    var items: [(String, String)] = [
    //        ("Marcelo Lebre", "Logo Pin"),
    //        ("Job van der Voort", "Logo Pin"),
    //        ("Carla Matos", "Logo Pin"),
    //        ("Rita Loureiro", "Logo Pin"),
    //        ("Maçã Rocks", "Logo Pin")
    //    ]
    
    var items: [(String, String)] = []
    var friendArray:[(String,Int)] = []
    
    @IBAction func next(sender: AnyObject) {
        var controller = MainMapViewController(nibName:"MainMapViewController", bundle:nil)
        //        var controller = MainMapViewController(nibName:"MainMapViewController", bundle:nil)
        //        self.presentViewController(controller, animated: true, completion: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"handleGetFriendsNotification:",
            name: "getFriendsNotification",
            object: nil)

        var user = User()
        friendArray = user.getFriends()
        
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
    
    
    
}