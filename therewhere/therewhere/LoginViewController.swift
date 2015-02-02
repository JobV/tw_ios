//
//  LoginViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 14/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func login(sender: UIButton) {
        // === SET YOUR ID ===
        var userProfile = UserProfile.sharedInstance
        userProfile.userID = "1"
        // ===================
        
        var user = User()
        var friends = Friends()
//        friends.getLocation("1")
//        friends.getLocation("2")
        //user.getUserInfo()
        //user.addFriends(["333333333","4444444444"])
        //user.createUser("firstname", lastName: "lastname", phoneNumber: "333333333", email: "email@email.com")
        var meetups = Meetups()
        meetups.requestMeetup("2")
        meetups.getPendingMeetups()

     //   meetups.getMeetupRequests();
        
        var controller = InviteFriendsViewController(nibName:"InviteFriendsViewController",bundle:nil)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true;

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
