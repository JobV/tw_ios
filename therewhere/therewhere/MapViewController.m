//
//  MapViewController.m
//  therewhere
//
//  Created by Marcelo Lebre on 15/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import "MapViewController.h"
#import "LTInfiniteScrollView.h"

#define color [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]
#define scrollViewHeight 100

@interface MapViewController () <LTInfiniteScrollViewDelegate,LTInfiniteScrollViewDataSource>
@property (nonatomic,strong) LTInfiniteScrollView* scrollView;
@property (nonatomic) CGFloat viewSize;
@end

@implementation MapViewController
@synthesize master,aView,aView2;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * viewWithBlurredBackground = [[UIVisualEffectView alloc] initWithEffect:effect];
    UIVisualEffectView * viewInducingVibrancy = [[UIVisualEffectView alloc] initWithEffect:effect]; // must be the same effect as the blur view
    [viewWithBlurredBackground.contentView addSubview:viewInducingVibrancy];
    UILabel * vibrantLabel = [UILabel new];
    // Set the text and the position of your label
    [viewInducingVibrancy.contentView addSubview:vibrantLabel];
    [self.view addSubview:viewInducingVibrancy];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.scrollView = [[LTInfiniteScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-110, CGRectGetWidth(self.view.bounds), scrollViewHeight)];
    [self.view addSubview:self.scrollView];
    //self.scrollView.delegate = self;
    self.scrollView.dataSource = self;
    
    self.viewSize = CGRectGetWidth(self.view.bounds) / 5.0f;
    [self.scrollView reloadData];
    
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.scrollView addGestureRecognizer:recognizer];
}

-(void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.scrollView];
    
    int centerIndex = self.scrollView.currentIndex;
    NSArray* indexNeeded = @[[NSNumber numberWithInt:centerIndex-2],[NSNumber numberWithInt:centerIndex-1],[NSNumber numberWithInt:centerIndex],[NSNumber numberWithInt:centerIndex+1],[NSNumber numberWithInt:centerIndex+2]];
    NSMutableArray* views = [NSMutableArray array];
    
    for (NSNumber *index in indexNeeded){
        UIView* view = [self.scrollView viewAtIndex:[index intValue]];
        
        
        [views addObject:view];
    }
    
    for (int i = 0; i< views.count;i++) {
        UIView* view = views[i];
        CGPoint center = view.center;
        center.y = center.y + translation.y * (1-fabs(i-2)*0.25);
        if(center.y< (scrollViewHeight-70) && center.y > 70){
            view.center = center;
        }
    }
    
    [recognizer setTranslation:CGPointZero inView:self.scrollView];
    
    [self.scrollView scrollToIndex:self.scrollView.currentIndex];
    self.scrollView.scrollEnabled = NO;
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
            for (UIView* view in views) {
                CGPoint center = view.center;
                center.y = CGRectGetMidY(self.scrollView.bounds);
                view.center = center;
            }
        } completion:^(BOOL finished) {
            self.scrollView.scrollEnabled = YES;
        }];
    }
}

- (IBAction)reload:(id)sender {
    self.scrollView.delegate = nil;
    [self.scrollView reloadData];
}

- (IBAction)reloadWithFancyEffect:(id)sender {
    self.scrollView.delegate = self;
    [self.scrollView reloadData];
}

-(int) totalViewCount
{
    return 10;
}

-(int) visibleViewCount
{
    return 5;
}

-(UIView*) viewAtIndex:(int)index reusingView:(UIView *)view;
{
   // if(view){
   //     ((UILabel*)view).text = [NSString stringWithFormat:@"%d", index];
   //     return view;
   // }
    
    if(view){
        [view viewWithTag:1].backgroundColor =
            [UIColor colorWithPatternImage:[UIImage imageNamed:@"darth"]];
            //((UILabel*)[view viewWithTag:2]).text = @"vader";
        return view;
    }
    
    
    master = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.viewSize, self.viewSize)];
    
    aView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewSize, self.viewSize)];
    aView.layer.cornerRadius = self.viewSize/2.0f;
    aView.layer.masksToBounds = YES;
    aView.textColor = [UIColor whiteColor];
    aView.textAlignment = NSTextAlignmentCenter;
    aView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darth"]];
    aView.tag = 1;
    
    aView2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.viewSize, self.viewSize)];
    aView2.textColor = [UIColor whiteColor];
    aView2.textAlignment = NSTextAlignmentCenter;
    aView2.text=@"vader";
    aView2.tag = 2;
    [master addSubview:aView];
    [master addSubview:aView2];
    
    
    
    return master;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
