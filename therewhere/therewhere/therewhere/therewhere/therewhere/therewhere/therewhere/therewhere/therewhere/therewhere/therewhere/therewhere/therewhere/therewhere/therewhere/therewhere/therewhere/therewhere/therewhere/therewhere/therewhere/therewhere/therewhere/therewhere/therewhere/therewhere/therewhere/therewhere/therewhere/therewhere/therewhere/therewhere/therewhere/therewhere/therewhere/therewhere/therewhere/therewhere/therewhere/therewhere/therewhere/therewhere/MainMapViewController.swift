//
//  MainMapViewController.swift
//  therewhere
//
//  Created by Marcelo Lebre on 15/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController{

    
    @IBOutlet var mapView: MKMapView!
    
    var scrollView: LTInfiniteScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = LTInfiniteScrollView(frame:CGRectMake(10,0,100, 200))
        self.view.addSubview(scrollView)
//        scrollView.dataSource = self
        scrollView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func totalViewCount() -> Int {
        return 1000
    }
    
    func visibleViewCount() -> Int
    {
        return 5;
    }
    
    func viewAtIndex(index: Int32, reusingView view: UIView!) -> UIView! {
        if((view) != nil){
        //    ((UILabel*)view).text = [NSString stringWithFormat:@"%d", index];
            var label = view as? UILabel
            label?.text = String(index)
            return label;
        }
        var aView = UILabel(frame:CGRectMake(0, 0, 64, 64))

        aView.backgroundColor = UIColor.blackColor()
        aView.layer.cornerRadius = 32
        aView.layer.masksToBounds = true
        aView.backgroundColor = UIColor(red: 0/255.0, green: 175/255, blue: 240/255.0, alpha: 1)
        aView.textColor = UIColor.whiteColor()
        aView.textAlignment = NSTextAlignment.Center
        aView.text = String(index);
        return aView
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
