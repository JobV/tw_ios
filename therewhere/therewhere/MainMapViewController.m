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


@interface MainMapViewController () <AKPickerViewDataSource, AKPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    
}
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MainMapViewController
@synthesize navigateButton, meetButton, contactButton;
@synthesize mapView;
static UIView *mainView;
static UIImageView* imgView;

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
    [locationManager startUpdatingLocation];
    
    [locationManager requestWhenInUseAuthorization];
    
    [mapView setShowsUserLocation:YES];
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
    [self.pickerView reloadData];
    mainView = [[UIView alloc]init];
    mainView = self.view;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return 10;
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

+ (void) contactUser{
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, mainView.bounds.size.width-75, 70, 70)];
    imgView.image = [UIImage imageNamed:@"darth"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    imgView.clipsToBounds = YES;
    imgView.layer.borderWidth = 3.0f;
    imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [imgView setTag:10];
    [self changeView];
}

- (void) changeView{
    if (self.pickerView.userInteractionEnabled) {
        [self enableButtons];
        self.pickerView.userInteractionEnabled = NO;
        [self.view addSubview:imgView];
        self.pickerView.hidden = YES;
    }else{
        [self disableButtons];
        self.pickerView.hidden = NO;
        self.pickerView.userInteractionEnabled = YES;
        UIView *img;
        if((img = [self.view viewWithTag:10]) != nil) {
            [img removeFromSuperview];
        }
    }
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

- (IBAction)interItemButton:(id)sender {
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-75, 70, 70)];
    imgView.image = [UIImage imageNamed:@"darth"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    imgView.clipsToBounds = YES;
    imgView.layer.borderWidth = 3.0f;
    imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [imgView setTag:10];
    
    
 
//    self.pickerView.interitemSpacing =
//        self.pickerView.interitemSpacing == 2.5 ?
//        (self.view.bounds.size.width-90) : 2.5;
    
    if (self.pickerView.userInteractionEnabled) {
        [self enableButtons];
        self.pickerView.userInteractionEnabled = NO;
        [self.view addSubview:imgView];
        self.pickerView.hidden = YES;
    }else{
        [self disableButtons];
        self.pickerView.hidden = NO;
        self.pickerView.userInteractionEnabled = YES;
        UIView *img;
        if((img = [self.view viewWithTag:10]) != nil) {
            [img removeFromSuperview];
        }
    }
    
 //   [self.pickerView reloadData];
    
}
- (void) disableButtons {
    meetButton.hidden = true;
    contactButton.hidden = true;
    navigateButton.hidden = true;
}
- (void) enableButtons {
    meetButton.hidden = false;
    contactButton.hidden = false;
    navigateButton.hidden = false;
}
/* Map Related */

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 250, 250);
    [mapView setRegion:region animated:YES];
}

/* User actions */
- (IBAction)meet:(id)sender {
}
- (IBAction)navigate:(id)sender {
}
- (IBAction)contact:(id)sender {
}


@end
