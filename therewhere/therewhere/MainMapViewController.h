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
- (IBAction)interItemButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *meetButton;
- (IBAction)meet:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *navigateButton;
- (IBAction)navigate:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;
- (IBAction)contact:(id)sender;
- (void)disableButtons;
- (void)enableButtons;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end
