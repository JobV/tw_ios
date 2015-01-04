//
//  MainMapViewController.m
//  therewhere
//
//  Created by Marcelo Lebre on 19/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import "MainMapViewController.h"
#import "AKPickerView.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RestKit.h>
#import "SetLocationRequest.h"
#import "SetLocationResponse.h"
#import "Location.h"
#import "therewhere-Swift.h"

@interface MainMapViewController () <AKPickerViewDataSource, AKPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    
}
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MainMapViewController
@synthesize navigateButton, meetButton, contactButton;
@synthesize mapView;

static Boolean buttonVisibility;
static NSString *friendName;
static NSString *friendID;
static UIButton *friendProfileButton;

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.navigationController.navigationBarHidden = true;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-75, self.view.bounds.size.width, 75)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pickerView setTag:1];
    [self.view addSubview:self.pickerView];

    self.pickerView.interitemSpacing = 2.5;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyleFlat;



    
 /*   self.titles = @[@"Tokyo",
                    @"Kanagawa",
                    @"Osaka",
                    @"Aichi",
                    @"Saitama",
                    @"Chiba",
                    @"Hyogo",
                    @"Hokkaido",
                    @"Fukuoka",
                    @"Shizuoka"];
    */
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    
    
    [mapView setShowsUserLocation:YES];
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
    
    friendProfileButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [friendProfileButton addTarget:self action:@selector(showFriendProfile)
                  forControlEvents:UIControlEventTouchUpInside];
    [friendProfileButton setTitle:@"Job" forState:UIControlStateNormal];
    friendProfileButton.frame = CGRectMake(245.0, 60, 65, 65);
    friendProfileButton.layer.cornerRadius = friendProfileButton.frame.size.width / 2;;
    friendProfileButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [friendProfileButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    friendProfileButton.layer.shadowRadius = 3.0f;
    friendProfileButton.layer.shadowColor = [UIColor blackColor].CGColor;
    friendProfileButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    friendProfileButton.layer.shadowOpacity = 0.5f;
    friendProfileButton.layer.masksToBounds = NO;
    friendProfileButton.hidden = true;
    
    [self.view addSubview:friendProfileButton];
    
    [self.pickerView reloadData];
    
    // Create content and menu controllers
    //
   }

- (void) showFriendProfile{
    FriendProfileViewController *fpvc = [[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
    [self.navigationController pushViewController:fpvc animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    NSLog(@"location.y: %f", location.y);
    [AKPickerView showScrollView];
    friendProfileButton.hidden = true;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickeNSLogrView
{
    return 10;
}

+ (void) showFriendProfileButton {
    friendProfileButton.hidden = false;
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *


*- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
*{
*    return self.titles[item];
*}
 */

 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
     UIImage *image =[UIImage imageNamed:@"darth"];

	return image;
 }



- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    
    //    self.pickerView.interitemSpacing =
    //        self.pickerView.interitemSpacing == 2.5 ?
    //        (self.view.bounds.size.width-90) : 2.5;
    
   
//   [self.pickerView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/* Map Related */

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 250, 250);
    [mapView setRegion:region animated:YES];

    Location *location = [[Location alloc] init];
    [location setLocation:newLocation.coordinate userID:1];
    
    CLLocationCoordinate2D loc = [location getLocation:1];
;
}



/*- (IBAction)friendProfile:(id)sender {
    FriendProfileViewController *fpvc = [[FriendProfileViewController alloc] initWithNibName:@"FriendProfileViewController" bundle:nil];
    [self.navigationController pushViewController:fpvc animated:YES];
}
 */
@end
