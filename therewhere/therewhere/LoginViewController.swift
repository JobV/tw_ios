
//  LoginViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 14/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

import UIKit

// Login view delegates
class LoginViewController: UIViewController, FBLoginViewDelegate{
    var fbloginView: FBLoginView = FBLoginView()
    
    @IBOutlet var loginBackground: UIImageView!
    @IBOutlet var fbButtonContainer: SpringView!
    @IBAction func friendListButton(sender: AnyObject) {
        var controller = InviteFriendsViewController(nibName:"InviteFriendsViewController",bundle:nil)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide navigation bar
        navigationController?.navigationBarHidden = true;
                
        // Set FB settings
        fbloginView.delegate = self
        fbloginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        // Animate the FB login button falling down
        fbButtonContainer.animation = "slideDown"
        fbButtonContainer.animate()
        
    }
    
    // Callback function triggered when user successfully logs in
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        var controller = InviteFriendsViewController(nibName:"InviteFriendsViewController",bundle:nil)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // Callback function triggered when user successfully logs out
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    // Fetching user info callback post-login
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        var userProfile = UserProfile.sharedInstance
        var token:String = FBSession.activeSession().accessTokenData.accessToken
        
        // Manually set user id
        userProfile.userID = "1"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
