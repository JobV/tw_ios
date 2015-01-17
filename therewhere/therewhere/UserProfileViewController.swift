//
//  UserProfileViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 17/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

@objc class UserProfileViewController: UIViewController {
    
    @IBOutlet var userProfileImage: UIImageView!
    
    @IBOutlet var userProfileName: UILabel!
    
    @IBOutlet var userProfileLocation: UILabel!
    
    @IBOutlet var userVisibilitySwitch: UISegmentedControl!
    
    @IBAction func userVisibilitySwitch(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            //  textLabel.text = "First selected";
            self.userProfileImage.layer.borderColor = UIColor.greenColor().CGColor
        case 1:
            //   textLabel.text = "Second Segment selected";
            self.userProfileImage.layer.borderColor = UIColor.yellowColor().CGColor
        case 2:
            //   textLabel.text = "Second Segment selected";
            self.userProfileImage.layer.borderColor = UIColor.grayColor().CGColor
        default:
            break;
        }
    }
    
    @IBOutlet var changeUserProfilePhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userProfile = UserProfile.sharedInstance
        userProfileName.text = userProfile.firstName + userProfile.lastName
        navigationController?.navigationBarHidden = false;
        
        self.userProfileImage.layer.cornerRadius = userProfileImage.layer.frame.size.width/2;
        
        self.userProfileImage.clipsToBounds = true;
        //
        self.userProfileImage.layer.borderWidth = 3.0;
        self.userProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
        
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
