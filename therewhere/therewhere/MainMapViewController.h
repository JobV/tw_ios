//
//  MainMapViewController.h
//  therewhere
//
//  Created by Marcelo Lebre on 19/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MainMapViewController : UIViewController
- (IBAction)meet:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *meetButton;
@property (strong, nonatomic) IBOutlet UIButton *navigateButton;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;

- (IBAction)navigate:(id)sender;
- (IBAction)contact:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end
