//
//  MapViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 21/02/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit
import MapKit
import JGProgressHUD

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager = CLLocationManager()
    var validLocations = false
    var firstTimeOpeningMap = true
    var myTimer = NSTimer()
    var showDirection:Bool = false
    var friendProfile = FriendProfile()
    var directionsRequest = MKDirectionsRequest()
    var directions = MKDirections()
    let friendPin = CustomPointAnnotation()
    var userPin = CustomPointAnnotation()
    var userProfile = UserProfile.sharedInstance
    
    @IBOutlet var optionsButton: UIButton!
    @IBAction func optionsButton(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let callAction = UIAlertAction(title: "Call", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            var alertController = UIAlertController()
            
            if(self.friendProfile.phoneNumber != ""){
                alertController = UIAlertController(title: "Calling Friend!",
                    message: "Do you want to call \(self.friendProfile.firstName)?",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let callingActionHandler = { (action:UIAlertAction!) -> Void in
                    UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(self.friendProfile.phoneNumber)")!)
                    return Void()
                }
                
                alertController.addAction(UIAlertAction(title: "Hum..nah", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Yes please", style: UIAlertActionStyle.Destructive, handler: callingActionHandler))
            }else{
                alertController = UIAlertController(title: "Calling Friend!",
                    message: "Sorry, your friend's number isn't available.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            }
            
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        let navigateAction = UIAlertAction(title: "Navigate to friend", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in

            var start = self.userPin.coordinate
            var destination = self.friendPin.coordinate
            let alertController = UIAlertController(title: "Navigate with",
                message: "Choose your maps app:",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            var googleMapsURLString = "comgooglemaps://?saddr=\(start.latitude),\(start.longitude)&daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving"
            var googleURL = NSURL(string: googleMapsURLString)
            
            var appleMapsURLString = "http://maps.apple.com/?daddr=\(destination.latitude),\(destination.longitude)&saddr=\(start.latitude),\(start.longitude)"
            var appleMapsURL = NSURL(string: appleMapsURLString)
            
            if(UIApplication.sharedApplication().canOpenURL(googleURL!)){
                let googleMapsHandler = { (action:UIAlertAction!) -> Void in
                    UIApplication.sharedApplication().openURL(googleURL!)
                }
                
                alertController.addAction(UIAlertAction(title: "Google Maps!", style: UIAlertActionStyle.Default, handler: googleMapsHandler))
            }
            
            if(UIApplication.sharedApplication().canOpenURL(appleMapsURL!)){
                let appleMapsHandler = { (action:UIAlertAction!) -> Void in
                    UIApplication.sharedApplication().openURL(appleMapsURL!)
                }
                
                alertController.addAction(UIAlertAction(title: "Apple Maps!", style: UIAlertActionStyle.Default, handler: appleMapsHandler))
            }
            
            alertController.addAction(UIAlertAction(title: "Nah! Forget it", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
 
        })
        
        let shareAction = UIAlertAction(title: "Share", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        let stopAction = UIAlertAction(title: "Terminate Meetup", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            let alertController = UIAlertController(title: "Meetup!",
                message: "Terminate Meetup?",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let terminateActionHandler = { (action:UIAlertAction!) -> Void in
                var meetup = Meetups()
                
                meetup.terminateMeetup(String(self.friendProfile.friendID))
                self.myTimer.invalidate()
                var friendsViewController = InviteFriendsViewController(nibName:"InviteFriendsViewController", bundle:nil)
                self.presentViewController(friendsViewController, animated: true, completion: nil)
            }
            
            alertController.addAction(UIAlertAction(title: "Not yet", style: UIAlertActionStyle.Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Yeah!", style: UIAlertActionStyle.Destructive, handler: terminateActionHandler))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        optionMenu.addAction(callAction)
        optionMenu.addAction(navigateAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(stopAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

    @IBOutlet var userProfilePictureButton: UIButton!
    @IBAction func userProfilePictureButton(sender: AnyObject) {
        var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: userPin.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBOutlet var friendProfilePictureButton: UIButton!
    @IBAction func friendProfilePictureButton(sender: AnyObject) {
        var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: friendPin.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    var friendLocation = CLLocationCoordinate2D(latitude: 0,longitude: 0){
        didSet {
            if (firstTimeOpeningMap){
                var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                var region = MKCoordinateRegion(center: friendLocation, span: span)
                
                mapView.setRegion(region, animated: true)
                firstTimeOpeningMap = false
            }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func showFriendsList(sender: AnyObject) {
        var friendsViewController = InviteFriendsViewController(nibName:"InviteFriendsViewController", bundle:nil)
        
        self.presentViewController(friendsViewController, animated: true, completion: nil)
    }
    
    @IBAction func callFriendButton(sender: AnyObject) {
        
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        
    }
    
    func setFriend(friend:FriendProfile){
        friendProfile = friend
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.myTimer.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        var user = User()
        
        self.locationManager = CLLocationManager()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"updateFriendLocation:",
            name: "friendLocationUpdate",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"getFriendProfileImage:",
            name: "friendProfileImage",
            object: nil)
        
        user.getFriendProfilePicture(self.friendProfile.providerID)
        
        self.mapView.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "updateLocation", userInfo: nil, repeats: true)
        myTimer.fire()
        
        userProfilePictureButton.setImage(userProfile.profileImage, forState: UIControlState.Normal)
        userProfilePictureButton.layer.cornerRadius = userProfilePictureButton.layer.frame.size.height / 2
        userProfilePictureButton.layer.masksToBounds = true;
        userProfilePictureButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill;
        userProfilePictureButton.layer.borderColor = UIColor.whiteColor().CGColor
        userProfilePictureButton.layer.borderWidth = 2
    }
    
    func getFriendProfileImage(notification: NSNotification){
        var data = notification.object as! NSData
        if var friendProfileImage:UIImage = UIImage(data: data) {
            friendProfile.profileImage = friendProfileImage
            friendProfilePictureButton.setImage(friendProfile.profileImage, forState: UIControlState.Normal)
            friendProfilePictureButton.layer.cornerRadius = friendProfilePictureButton.layer.frame.size.height / 2
            friendProfilePictureButton.layer.masksToBounds = true;
            friendProfilePictureButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill;
            friendProfilePictureButton.layer.borderColor = UIColor.whiteColor().CGColor
            friendProfilePictureButton.layer.borderWidth = 2
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class CustomPointAnnotation: MKPointAnnotation {
        var image: UIImage!
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        mapView.removeAnnotation(userPin)
        userPin.coordinate = locValue
        userPin.title = "You"
        userPin.image = userProfile.profileImage
        mapView.addAnnotation(userPin)
    }
    
    func updateFriendLocation(notification: NSNotification){
        let notification_coordinates : [NSObject : AnyObject] = notification.userInfo!
        var coordinates = notification_coordinates["location"] as! Friends.Coordinates
        var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        friendLocation = coordinate
        
        if(!(friendLocation.longitude == 0 && friendLocation.latitude == 0)){
            mapView.removeAnnotation(friendPin)
            friendPin.coordinate = friendLocation
            friendPin.title = friendProfile.firstName
            friendPin.image = friendProfile.profileImage
            mapView.addAnnotation(friendPin)
        }
    }
    
    func updateLocation(){
        var friendID = String(friendProfile.friendID)
        var friends = Friends()
        
        friends.getLocation(friendID)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "location"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView.canShowCallout = true
        }
        else {
            annotationView.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        
        annotationView.image = customPointAnnotation.image
        annotationView.canShowCallout = false;
        annotationView.frame = CGRectMake(0, 0, 40, 40);
        annotationView.layer.cornerRadius = annotationView.frame.size.height / 2
        annotationView.layer.masksToBounds = true;
        annotationView.contentMode = UIViewContentMode.ScaleAspectFill;
        
        return annotationView
    }
}
