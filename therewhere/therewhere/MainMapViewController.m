//
//  MainMapViewController.m
//  therewhere
//
//  Created by Marcelo Lebre on 19/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import "MainMapViewController.h"
#import "AKPickerView.h"


@interface MainMapViewController () <AKPickerViewDataSource, AKPickerViewDelegate>
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation MainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView = [[AKPickerView alloc] initWithFrame:self.view.bounds];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pickerView];

//    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
//    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.pickerView.interitemSpacing = 20.0;
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
    [self.pickerView reloadData];
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



- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
 //   NSLog(@"%@", self.titles[item]);
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

@end
