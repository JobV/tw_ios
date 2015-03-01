//
//  MapViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 21/02/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet
    var buttonColor: UIColor? = UIColor.greenColor()
    let locationManager = CLLocationManager()

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
        }
        
        alertController.addAction(UIAlertAction(title: "Not yet", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yeah!", style: UIAlertActionStyle.Destructive, handler: terminateActionHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    @IBOutlet var navigateButton: UIButton!
    @IBAction func navigateButton(sender: AnyObject) {
    }
    
    func setColor(color:UIColor){
        buttonColor = color
    }
    
    func setFriendID(friendID:Int){
        mapFriendID = friendID
    }
    
    var mapFriendID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false;
        callButton.backgroundColor = buttonColor
        stopButton.backgroundColor = buttonColor
        navigateButton.backgroundColor = buttonColor
        if(buttonColor == UIColor.whiteColor()){
            callButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            stopButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            navigateButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        }
        
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
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        let location = locations.last as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        var dropPin = MKPointAnnotation()
        dropPin.coordinate = locValue
        dropPin.title = "You"
        mapView.addAnnotation(dropPin)
        self.mapView.setRegion(region, animated: true)
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
