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
    
    
    @IBOutlet
    var buttonColor: UIColor? = UIColor.greenColor()
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
    
    @IBOutlet var callButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func showFriendsList(sender: AnyObject) {
        var friendsViewController = InviteFriendsViewController(nibName:"InviteFriendsViewController", bundle:nil)
        
        self.presentViewController(friendsViewController, animated: true, completion: nil)
    }
    
    @IBAction func callFriendButton(sender: AnyObject) {
        var alertController = UIAlertController()
        
        if(self.friendProfile.phoneNumber != ""){
            alertController = UIAlertController(title: "Calling Friend!",
                message: "Do you want to call \(friendProfile.firstName)?",
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
    }
    
    @IBAction func stopButton(sender: AnyObject) {
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
    }
    
    func setColor(color:UIColor){
        buttonColor = color
    }
    
    func setFriend(friend:FriendProfile){
        friendProfile = friend
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.myTimer.invalidate()
        self.mapView.removeFromSuperview()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.locationManager = CLLocationManager()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"updateFriendLocation:",
            name: "friendLocationUpdate",
            object: nil)
        
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callButton.backgroundColor = buttonColor
        stopButton.backgroundColor = buttonColor
        
        if(buttonColor == UIColor.whiteColor()){
            callButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            stopButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        }
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
            friendPin.image = UIImage(named: "location_green")
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
