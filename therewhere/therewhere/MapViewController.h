//
//  MapViewController.h
//  therewhere
//
//  Created by Marcelo Lebre on 15/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIView* master;
@property (strong, nonatomic) UILabel* aView;
@property (strong, nonatomic) UILabel* aView2;
@end
