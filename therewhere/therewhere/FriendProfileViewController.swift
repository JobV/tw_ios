//
//  FriendProfileViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 03/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {
    @IBOutlet var profileImage: UIImageView!
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
//        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
        profileImage.layer.cornerRadius = profileImage.layer.frame.size.width/2;
 //       cell.imageView.clipsToBounds = YES;
        profileImage.clipsToBounds = true;
  //      cell.imageView.layer.borderWidth = 3.0f;
        profileImage.layer.borderWidth = 3.0;
   //     cell.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        // Do any additional setup after loading the view.
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
