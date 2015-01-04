//
//  FriendProfileViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 03/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

@objc class FriendProfileViewController: UIViewController {
    @IBOutlet  var profileImage: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profileLocation: UILabel!
    
    @IBAction func alwaysShareSwitch(sender: AnyObject) {
    }
    
    @IBOutlet var alwaysShareSwitch: UISwitch!
    
    
    @IBAction func getNotificationWhenNearSwitch(sender: AnyObject) {
    }
    @IBOutlet var getNotificationWhenNearSwitch: UISwitch!
    
    
    @IBOutlet var requestLocationSharing: UIButton!
    
    @IBAction func requestLocationSharing(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false;
       self.profileImage.layer.cornerRadius = profileImage.layer.frame.size.width/2;

        self.profileImage.clipsToBounds = true;
//
        self.profileImage.layer.borderWidth = 3.0;
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
