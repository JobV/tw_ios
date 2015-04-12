//
//  MapViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 21/02/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit
import MapKit
import SwiftSpinner

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet
    var buttonColor: UIColor? = UIColor.greenColor()
    var locationManager = CLLocationManager()
    let userPin = MKPointAnnotation()
    let friendPin = MKPointAnnotation()
    var friendLocation = CLLocationCoordinate2D(latitude: 0,longitude: 0){
        didSet {
            SwiftSpinner.hide()
        }
    }
    
    var myTimer = NSTimer()
    var showDirection:Bool = false
    var friendProfile = FriendProfile()
    var directionsRequest = MKDirectionsRequest()
    var directions = MKDirections()
    var myRoute : MKRoute?
    
    @IBOutlet var callButton: UIButton!
    @IBOutlet var navigateButton: UIButton!
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
    
    @IBAction func navigateButton(sender: AnyObject) {
        if(self.myRoute? != nil){
            if showDirection {
                showDirection = false
                self.mapView.removeOverlay(self.myRoute?.polyline)
            }
            else{
                showDirection = true
                self.mapView.addOverlay(self.myRoute?.polyline)
            }
        }else{
            var alertController = UIAlertController(title: "Friend Location!",
                message: "Sorry, your friend's location isn't available.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func setColor(color:UIColor){
        buttonColor = color
    }
    
    
    func setFriendProfile(friend:FriendProfile){
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
        
        if(!(friendLocation.longitude == 0 && friendLocation.latitude == 0)){
            println("centering map")
            var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            var region = MKCoordinateRegion(center: friendLocation, span: span)
            
            mapView.setRegion(region, animated: true)
        }else{
            println("not centering map")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callButton.backgroundColor = buttonColor
        stopButton.backgroundColor = buttonColor
        navigateButton.backgroundColor = buttonColor
        
        if(buttonColor == UIColor.whiteColor()){
            callButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            stopButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            navigateButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        }
        
        if(!(friendLocation.longitude == 0 && friendLocation.latitude == 0)){
            println("centering map")
            var span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            var region = MKCoordinateRegion(center: friendLocation, span: span)
            
            mapView.setRegion(region, animated: true)
        }else{
            println("not centering map")
        }
        
        SwiftSpinner.show("Connecting to satellite...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        
        userPin.coordinate = locValue
        userPin.title = "You"
        
        mapView.removeAnnotation(userPin)
        mapView.addAnnotation(userPin)
    }
    
    func updateFriendLocation(notification: NSNotification){
        let notification_coordinates : [NSObject : AnyObject] = notification.userInfo!
        var coordinates = notification_coordinates["location"] as! Friends.Coordinates
        var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        friendLocation = coordinate
        
        if(!(friendLocation.longitude == 0 && friendLocation.latitude == 0)){
            let markC1 = MKPlacemark(coordinate: userPin.coordinate, addressDictionary: nil)
            let markC2 = MKPlacemark(coordinate: friendLocation, addressDictionary: nil)
            
            friendPin.coordinate = friendLocation
            friendPin.title = friendProfile.firstName
            
            mapView.removeAnnotation(friendPin)
            mapView.addAnnotation(friendPin)
            
            directionsRequest.setSource(MKMapItem(placemark: markC1))
            directionsRequest.setDestination(MKMapItem(placemark: markC2))
            directionsRequest.transportType = MKDirectionsTransportType.Automobile
            directions = MKDirections(request: directionsRequest)
            
            directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
                if error == nil {
                    self.mapView.removeOverlay(self.myRoute?.polyline)
                    self.myRoute = response.routes[0] as? MKRoute
                    self.mapView.addOverlay(self.myRoute?.polyline)
                }
            }
        }
    }
    
    func updateLocation(){
        var friendID = String(friendProfile.friendID)
        var friends = Friends()
        
        friends.getLocation(friendID)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let identifier = "my_location"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView!.canShowCallout = true
            
            if pinView.annotation.title! == "You" {
                pinView.image = UIImage(named: "location_green")
            }else{
                pinView.image = UIImage(named: "location_blue")
            }
        }
        else {
            pinView.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if showDirection {
            var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
            var color = UIColor.blueColor()
            var colorWithAlpha = color.colorWithAlphaComponent(0.5)
            
            myLineRenderer.strokeColor = colorWithAlpha
            myLineRenderer.lineWidth = 3
            
            return myLineRenderer
        }
        return nil
    }
    
}
