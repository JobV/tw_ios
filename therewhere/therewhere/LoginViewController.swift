//
//  LoginViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 14/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate{
    var fbloginView: FBLoginView = FBLoginView()
    @IBOutlet var loginView : FBLoginView?
    
    @IBAction func login(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true;
        fbloginView.delegate = self
        fbloginView.readPermissions = ["public_profile", "email", "user_friends"]
        fbloginView.center = self.view.center
        self.view.addSubview(fbloginView)

        
        
        
        // Do any additional setup after loading the view.
    }
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        var controller = InviteFriendsViewController(nibName:"InviteFriendsViewController",bundle:nil)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        println("User Name: \(user.name)")
        println("User Name: \(user.objectID)")
        var token:String = FBSession.activeSession().accessTokenData.accessToken
        println("token: \(token)")
        var handler = FacebookHandler()
        handler.getFriends("/me/friends")
        // === SET YOUR ID ===
        var userProfile = UserProfile.sharedInstance
        userProfile.userID = "1"
        // ===================
        
        var user = User()
        var friends = Friends()
        //friends.getLocation("1")
        //friends.getLocation("2")
        //user.getUserInfo()
        //user.addFriends(["333333333","4444444444"])
        //user.createUser("firstname", lastName: "lastname", phoneNumber: "333333333", email: "email@email.com")
        //   meetups.getMeetupRequests();
        
        
    }
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication:NSString?, annotation: AnyObject) -> Bool {
////        [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
