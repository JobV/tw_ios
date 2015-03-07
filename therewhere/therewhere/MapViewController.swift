//
//  MapViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 21/02/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet
    var buttonColor: UIColor? = UIColor.greenColor()
    let locationManager = CLLocationManager()
    var userPin = MKPointAnnotation()
    var friendPin = MKPointAnnotation()
    var friendLocation = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    
    @IBOutlet var callButton: UIButton!
    @IBAction func callButton(sender: AnyObject) {
    }
    
    @IBOutlet var stopButton: UIButton!
    @IBAction func stopButton(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Meetup!",
            message: "Terminate Meetup?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let terminateActionHandler = { (action:UIAlertAction!) -> Void in
            var meetup = Meetups()
            meetup.terminateMeetup(String(self.mapFriendID))
            self.navigationController?.popViewControllerAnimated(true)
            self.myTimer.invalidate()
        }
        
        alertController.addAction(UIAlertAction(title: "Not yet", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yeah!", style: UIAlertActionStyle.Destructive, handler: terminateActionHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBOutlet var navigateButton: UIButton!
    @IBAction func navigateButton(sender: AnyObject) {
        if showDirection {
            showDirection = false
            self.mapView.removeOverlay(self.myRoute?.polyline)
        }
        else{
            showDirection = true
            self.mapView.addOverlay(self.myRoute?.polyline)
        }
    }
    
    func setColor(color:UIColor){
        buttonColor = color
    }
    
    func setFriendID(friendID:Int){
        mapFriendID = friendID
    }
    func setFriendName(friendName:String){
        mapFriendName = friendName
    }
    
    var mapFriendID:Int = 0
    var mapFriendName:String = ""
    var myTimer = NSTimer()
    var showDirection:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"updateFriendLocation:",
            name: "friendLocationUpdate",
            object: nil)
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "updateLocation", userInfo: nil, repeats: true)
        myTimer.fire()
        
        navigationController?.navigationBarHidden = false;
        callButton.backgroundColor = buttonColor
        stopButton.backgroundColor = buttonColor
        navigateButton.backgroundColor = buttonColor
        if(buttonColor == UIColor.whiteColor()){
            callButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            stopButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            navigateButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        }
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
    }
    
    @IBOutlet var mapView: MKMapView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }
    var directionsRequest = MKDirectionsRequest()
    var directions = MKDirections()
    var myRoute : MKRoute?
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        let location = locations.last as CLLocation
        
        //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        var user = User()
        user.setLocation(locValue)
        
        userPin.coordinate = locValue
        userPin.title = "You"
        
        mapView.removeAnnotation(userPin)
        mapView.addAnnotation(userPin)
        
    }
    
    func updateFriendLocation(notification: NSNotification){
        println("updating friend location")
        let tmp : [NSObject : AnyObject] = notification.userInfo!
        var coordinates = tmp["location"] as Friends.Coordinates
        var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        friendLocation = coordinate
        if(!(friendLocation.longitude == 0 && friendLocation.latitude == 0)){
            friendPin.coordinate = friendLocation
            friendPin.title = mapFriendName
            mapView.removeAnnotation(friendPin)
            mapView.addAnnotation(friendPin)
            
            let markC1 = MKPlacemark(coordinate: userPin.coordinate, addressDictionary: nil)
            let markC2 = MKPlacemark(coordinate: friendLocation, addressDictionary: nil)
            
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
        var friendID = String(mapFriendID)
        var friends = Friends()
        friends.getLocation(friendID)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let identifier = "my_location"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if pinView == nil {
            //println("Pinview was nil")
            
            //Create a plain MKAnnotationView if using a custom image...
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            pinView!.canShowCallout = true
            pinView.image = UIImage(named: "location_green")
        }
        else {
            //Unrelated to the image problem but...
            //Update the annotation reference if re-using a view...
            pinView.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
        var color = UIColor.blueColor()
        var colorWithAlpha = color.colorWithAlphaComponent(0.5)
        myLineRenderer.strokeColor = colorWithAlpha
        myLineRenderer.lineWidth = 3
        return myLineRenderer
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
