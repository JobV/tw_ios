
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
    var fbCounter = 0
    
    @IBOutlet var loginBackground: UIImageView!
    @IBOutlet var fbButtonContainer: SpringView!
    @IBAction func friendListButton(sender: AnyObject) {
        var controller = InviteFriendsViewController(nibName:"InviteFriendsViewController",bundle:nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbCounter = 0
        //Register for authentication notifications
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"authenticationHandler:",
            name: "authenticationNotification",
            object: nil)
        
        // hide navigation bar
        navigationController?.navigationBarHidden = true;

        // Set FB settings
        fbloginView.delegate = self
        fbloginView.readPermissions = ["public_profile", "email", "user_friends", "user_about_me", "user_activities"]
        
        // Animate the FB login button falling down
        fbButtonContainer.animation = "slideDown"
        fbButtonContainer.animate()
        
    }
    
    // Callback function triggered when user successfully logs in
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        MixpanelHandler.userLogin()
    }
    
    // Callback function triggered when user successfully logs out
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        var user = User()
        
        user.logout()
        MixpanelHandler.userLogout()
        fbCounter = 0
    }
    
    // Fetching user info callback post-login
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        if(fbCounter == 0){
            var userProfile = UserProfile.sharedInstance
            var token:String = FBSession.activeSession().accessTokenData.accessToken
            var userAPI = User()
            
            userProfile.firstName = user.first_name
            userProfile.lastName = user.last_name
            userProfile.email = user.objectForKey("email") as! String
            userProfile.providerID = user.objectID
            userAPI.authenticate(token)
            userAPI.getUserProfilePicture()
            
            fbCounter+=1
        }
    }
    
    func authenticationHandler(object: NSNotification){
        var controller = InviteFriendsViewController(nibName:"InviteFriendsViewController",bundle:nil)
        
//        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
