//
//  AppDelegate.swift
//  therewhere
//
//  Created by Marcelo Lebre on 12/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var getOnGoingMeetupsTimer = NSTimer()
    
    func applicationDidEnterBackground(application: UIApplication) {
        getOnGoingMeetupsTimer.invalidate()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        var userProfile = UserProfile.sharedInstance
        // Only update background location if there's an ongoing meetup
        if(userProfile.onGoingMeetups > 0){
            var locValue:CLLocationCoordinate2D = manager.location.coordinate
            var user = User()
            
            user.setLocation(locValue)
        }
    }
    
    func updateOnGoingMeetups(){
        var meetups = Meetups()
        
        meetups.getPendingMeetups()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        getOnGoingMeetupsTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "updateOnGoingMeetups", userInfo: nil, repeats: true)
        getOnGoingMeetupsTimer.fire()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.locationManager.stopUpdatingLocation()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        MixpanelHandler.userOpensApplication()

        // Registering for notifications
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        var notificationActionOk :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionOk.identifier = "accept"
        notificationActionOk.title = "Ok"
        notificationActionOk.destructive = false
        notificationActionOk.authenticationRequired = false
        notificationActionOk.activationMode = UIUserNotificationActivationMode.Background
        
        var notificationActionCancel :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionCancel.identifier = "decline"
        notificationActionCancel.title = "Not Now"
        notificationActionCancel.destructive = true
        notificationActionCancel.authenticationRequired = false
        notificationActionCancel.activationMode = UIUserNotificationActivationMode.Background
        
        var notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "meetup"
        notificationCategory .setActions([notificationActionOk,notificationActionCancel], forContext: UIUserNotificationActionContext.Default)
        notificationCategory .setActions([notificationActionOk,notificationActionCancel], forContext: UIUserNotificationActionContext.Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert |
            UIUserNotificationType.Badge, categories: NSSet(array:[notificationCategory]) as Set<NSObject>
            ))

        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        
        return wasHandled
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    // Push Notifications
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Transforming deviceToken from data to string type
        var user = UserProfile.sharedInstance
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        user.deviceToken = deviceTokenString

        //only allow fb login to act after securing an APN token
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if let window = window {
            var loginviewcontroller = LoginViewController(nibName:"LoginViewController",bundle:nil)
            
            window.rootViewController = loginviewcontroller
            window.backgroundColor = UIColor.whiteColor()
            window.makeKeyAndVisible()
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
      
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        var userProfile = UserProfile.sharedInstance
        var meetup = Meetups()
        var mapViewController = MapViewController(nibName:"MapViewController",bundle:nil)
        var friend = FriendProfile()
        
        switch identifier!{
        case "accept":
            if var friendID:Int = userInfo["friend_id"] as? Int{
                friend.friendID = friendID
                meetup.acceptMeetup(toString(friendID))
                userProfile.incrementOnGoingMeetups()
                
                if var firstName:String = userInfo["first_name"] as? String{
                    friend.firstName = firstName
                }
                
                if var lastName:String = userInfo["last_name"] as? String{
                    friend.lastName = lastName
                }
                
                if var phoneNumber:String = userInfo["phone_nr"] as? String{
                    friend.phoneNumber = phoneNumber
                }
                
                mapViewController.setFriend(friend)
                
                var viewcontroller = mapViewController

                completionHandler()
            }

        case "decline":
            var meetup = Meetups()
            
            if var friendID:Int = userInfo["friend_id"] as? Int{
                meetup.declineToMeetup(toString(friendID))
            }
            
            completionHandler()
        default:
           println("action for notification not available")
        }
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Couldn't register: \(error)")
    }
    
    // Handle remote notifications
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        var inviteviewcontroller = InviteFriendsViewController(nibName:"InviteFriendsViewController", bundle:nil)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if let window = window {
            window.rootViewController = inviteviewcontroller
            window.backgroundColor = UIColor.whiteColor()
            window.makeKeyAndVisible()
        }
        
        var action = userInfo["action"] as! NSNumber!
        var aps = userInfo["aps"] as! NSDictionary
        var msg = aps["alert"] as! String
        let alert = UIAlertController(title: "Meetup Request", message: msg, preferredStyle: .Alert)
        
        switch action {
        case 1:
            // Receive meetup request
            let acceptActionHandler = { (action:UIAlertAction!) -> Void in
                var userProfile = UserProfile.sharedInstance
                var meetup = Meetups()
                var mapViewController = MapViewController(nibName:"MapViewController",bundle:nil)
                var friend = FriendProfile()
                
                if var friendID:Int = userInfo["friend_id"] as? Int{
                    friend.friendID = friendID
                    meetup.acceptMeetup(toString(friendID))
                    userProfile.incrementOnGoingMeetups()
                    
                    if var firstName:String = userInfo["first_name"] as? String{
                        friend.firstName = firstName
                    }
                    
                    if var lastName:String = userInfo["last_name"] as? String{
                        friend.lastName = lastName
                    }
                    
                    if var phoneNumber:String = userInfo["phone_nr"] as? String{
                        friend.phoneNumber = phoneNumber
                    }
                    
                    mapViewController.setFriend(friend)
                    self.window?.rootViewController?
                        .presentViewController(mapViewController, animated: true, completion: nil)
                }
            }
            
            let declineActionHandler = { (action:UIAlertAction!) -> Void in
                var meetup = Meetups()
                
                if var friendID:Int = userInfo["friend_id"] as? Int{
                    meetup.declineToMeetup(toString(friendID))
                }
            }
            
            alert.addAction(UIAlertAction(title: "Accept", style: .Default, handler: acceptActionHandler))
            alert.addAction(UIAlertAction(title: "Decline", style: .Destructive, handler: declineActionHandler))
            alert.addAction(UIAlertAction(title: "Delay", style: .Cancel, handler: nil))
        case 2:
            // Friend accepted a meetup request
            let viewMapActionHandler = { (action:UIAlertAction!) -> Void in
                var controller = MapViewController(nibName:"MapViewController",bundle:nil)
                var friend = FriendProfile()
                var userProfile = UserProfile.sharedInstance
                
                if var friendID:Int = userInfo["friend_id"] as? Int{
                    friend.friendID = friendID
                }
                
                if var firstName:String = userInfo["first_name"] as? String{
                    friend.firstName = firstName
                }
                
                if var lastName:String = userInfo["last_name"] as? String{
                    friend.lastName = lastName
                }
                
                if var phoneNumber:String = userInfo["phone_nr"] as? String{
                    friend.phoneNumber = phoneNumber
                }
                
                userProfile.incrementOnGoingMeetups()
                controller.setFriend(friend)
                
                self.window?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
            }
            
            alert.addAction(UIAlertAction(title: "View now", style: .Default, handler: viewMapActionHandler))
            alert.addAction(UIAlertAction(title: "Later!", style: .Default, handler: nil))
        case 3:
            // Friend declined a meetup request
            alert.addAction(UIAlertAction(title: "oh :/!", style: .Default, handler: nil))
        case 4:
            // Friend terminated a meetup
            var userProfile = UserProfile.sharedInstance
            
            alert.addAction(UIAlertAction(title: "Ok!", style: .Default, handler: nil))
            userProfile.decreaseOnGoingMeetups()
        default:
            println("nothing to be done")
        }
        
        window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "tw.therewhere" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("therewhere", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("therewhere.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
}

