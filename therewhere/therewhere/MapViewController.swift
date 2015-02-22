//
//  MapViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 21/02/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet
    var buttonColor: UIColor? = UIColor.greenColor()
    
    @IBOutlet var callButton: UIButton!
    @IBAction func callButton(sender: AnyObject) {
    }
    
    @IBOutlet var stopButton: UIButton!
    @IBAction func stopButton(sender: AnyObject) {
    }

    @IBOutlet var navigateButton: UIButton!
    @IBAction func navigateButton(sender: AnyObject) {
    }
    
    func setColor(color:UIColor){
        println(color)
        buttonColor = color
    }
    
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
