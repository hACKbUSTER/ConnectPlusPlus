//
//  ViewController.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/15.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "ViewController.h"
#import "AJLocationManager.h"
#import "UIView+ViewFrameGeometry.h"

#import "PointPeekViewController.h"

@import Mapbox;


@interface ViewController () <MGLMapViewDelegate,UIViewControllerPreviewingDelegate>


@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic)         CLLocationCoordinate2D currentLocation;
@property (nonatomic)         MGLCoordinateBounds currentVisibleBounds;
@property (nonatomic, strong) MGLPointAnnotation *currentUserAnnotation;
@property (nonatomic, strong) NSMutableArray *markerArray;

@property (nonatomic, strong) UIView *bottomToolBarView;

@property (nonatomic, strong) UIButton *bottomToolBarCameraButton;
@property (nonatomic, strong) UIButton *bottomToolBarMicroButton;

@property (nonatomic, strong) UIButton *topBarListButton;

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UILabel *topBarTitleView;

@property (nonatomic, strong) MGLAnnotationView *currentPointView;
@property (nonatomic, strong) CLHeading *cachedHeading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _markerArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *styleURL = [NSURL URLWithString:@"mapbox://styles/sergiochan/ciuaw89t4001p2io9pvhfsk3p"];
    _mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:styleURL];
    
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Set the delegate property of our map view to `self` after instantiating it.
    _mapView.delegate = self;

    _mapView.userTrackingMode = MGLUserTrackingModeFollowWithHeading;
    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = NO;
    _mapView.rotateEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    // Set the map’s center coordinate and zoom level.
//    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(59.31, 18.06)
//                       zoomLevel:1 direction:0 animated:YES completionHandler:^{
//                           weakSelf.currentUserAnnotation = [[MGLPointAnnotation alloc] init];
//                           weakSelf.currentUserAnnotation.coordinate = weakSelf.currentLocation;
//                           [weakSelf.mapView addAnnotation:weakSelf.currentUserAnnotation];
//                           
//                           [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//                               NSLog(@"fuck!");
//                               weakSelf.currentLocation = CLLocationCoordinate2DMake(locationCorrrdinate.latitude, locationCorrrdinate.longitude);
//                               [weakSelf.mapView setCenterCoordinate:weakSelf.currentLocation
//                                                   zoomLevel:15
//                                                    animated:YES];
//                               weakSelf.currentUserAnnotation.coordinate = locationCorrrdinate;
//                           } headingBlock:^(CLHeading *heading) {
//                               weakSelf.cachedHeading = heading;
//                               CGFloat degrees = fabs(180.0f - heading.trueHeading);
//                               NSLog(@"fuck!! %f",degrees);
//                               if (weakSelf.currentPointView) {
//                                   weakSelf.currentPointView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degrees/360.0f * M_PI);
//                               }
//                               
//                           }];
//                       }];
    
    [self.view addSubview:_mapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_mapView addGestureRecognizer:tap];
    
    _bottomToolBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, ScreenHeight - 55.0f, ScreenWidth, 55.0f)];
    _bottomToolBarView.backgroundColor = [UIColor blackColor];
    
    _bottomToolBarCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 110.0f, 7.5f, 40.0f, 40.0f)];
    _bottomToolBarCameraButton.backgroundColor = [UIColor clearColor];
    [_bottomToolBarCameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [_bottomToolBarView addSubview:_bottomToolBarCameraButton];
    
    _bottomToolBarMicroButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50.0f, 7.5f, 40.0f, 40.0f)];
    _bottomToolBarMicroButton.backgroundColor = [UIColor clearColor];
    [_bottomToolBarMicroButton setImage:[UIImage imageNamed:@"micphone"] forState:UIControlStateNormal];
    [_bottomToolBarView addSubview:_bottomToolBarMicroButton];
    
    [self.view addSubview:_bottomToolBarView];
    
    _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 80.0f)];
    _topBarView.backgroundColor = [UIColor clearColor];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithFrame:_topBarView.bounds];
    blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    [_topBarView addSubview:blurView];
    
    _topBarListButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 52.0f, 25.5f, 50.0f, 50.0f)];
    _topBarListButton.backgroundColor = [UIColor clearColor];
    [_topBarListButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [_topBarView addSubview:_topBarListButton];
    
    _topBarTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 200.0f, 40.0f)];
    _topBarTitleView.text = @"C o n n e c t + +";
    _topBarTitleView.textColor = [UIColor whiteColor];
    _topBarTitleView.font = [UIFont fontWithName:@"TT Cottons Light DEMO" size:30.0f];
    _topBarTitleView.textAlignment = NSTextAlignmentCenter;
    _topBarTitleView.center = CGPointMake(_topBarView.center.x, _topBarTitleView.center.y);
    
    [_topBarView addSubview:_topBarTitleView];
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 35.0f, 30.0f, 30.0f)];
    profileImageView.image = [UIImage imageNamed:@"Profile"];
    profileImageView.layer.cornerRadius = 15.0f;
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImageView.layer.borderWidth = 1.0f;
    
    [_topBarView addSubview:profileImageView];
    [self.view addSubview:_topBarView];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

-(float)randomFloatBetween:(float)num1 andLargerFloat:(float)num2
{
    int startVal = num1*10000;
    int endVal = num2*10000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a /10000.0);
}

- (void)tap:(UIGestureRecognizer *)gesture
{
    MGLPointAnnotation *testMarker = [[MGLPointAnnotation alloc] init];
    
    CGFloat latitude_delta = fabs(_mapView.visibleCoordinateBounds.ne.latitude - _mapView.visibleCoordinateBounds.sw.latitude) * 0.8f;
    CGFloat longitude_delta = fabs(_mapView.visibleCoordinateBounds.ne.longitude - _mapView.visibleCoordinateBounds.sw.longitude) * 0.8f;
    
    CLLocationCoordinate2D t = CLLocationCoordinate2DMake(self.currentLocation.latitude - latitude_delta/2.0f + [self randomFloatBetween:0.0f andLargerFloat:1.0f] * latitude_delta,self.currentLocation.longitude - longitude_delta/2.0f + [self randomFloatBetween:0.0f andLargerFloat:1.0f] * longitude_delta);
    testMarker.coordinate = t;
    testMarker.title = @"TAG";
    
    [self.mapView addAnnotation:testMarker];
    [_markerArray addObject:testMarker];
    if (_markerArray.count > 10) {
        [self.mapView removeAnnotation:[_markerArray objectAtIndex:0]];
        [_markerArray removeObjectAtIndex:0];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location
{
    for (MGLPointAnnotation *annotation in self.mapView.annotations)
    {
        MGLAnnotationView *annotationView = (MGLAnnotationView *)[self.mapView viewForAnnotation:annotation];
        if ([annotationView.layer containsPoint:location])
        {
            PointPeekViewController *peek = [[PointPeekViewController alloc] init];
            peek.view.frame = self.view.frame;
            return peek;
        }
    }
    
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit
{
    
}

#pragma mark - MGLMapViewDelegate Methods

- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(nullable MGLUserLocation *)userLocation
{
    self.currentLocation = userLocation.location.coordinate;
    NSLog(@"$$$%f",userLocation.heading.trueHeading);
}

// 这里是所见区域更新的回调方法，需要在这里重新请求界面上的数据点
- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    _currentVisibleBounds = mapView.visibleCoordinateBounds;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((mapView.visibleCoordinateBounds.ne.latitude + mapView.visibleCoordinateBounds.sw.latitude)/2.0f, (mapView.visibleCoordinateBounds.ne.longitude + mapView.visibleCoordinateBounds.sw.longitude)/2.0f);
    
    NSLog(@"regionDidChange! : %f,%f",center.latitude,center.longitude);
    
//    [[AJLocationManager shareLocation] startLocation];
}


- (void)mapViewDidFinishRenderingFrame:(MGLMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (fullyRendered) {
        //        [[AJLocationManager shareLocation] startLocation];
    }
}

- (void)mapView:(nonnull MGLMapView *)mapView
didSelectAnnotation:(nonnull id<MGLAnnotation>)annotation
{
    
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    return nil;
}

// Use the default marker. See also: our view annotation or custom marker examples.
- (nullable MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    
    MGLPointAnnotation *item = (MGLPointAnnotation *)annotation;
    
    if (![item.title isEqualToString:@"TAG"]) {
        NSString *reuseIdentifier = [NSString stringWithFormat:@"marker_%f", annotation.coordinate.longitude];

        MGLAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        
        if (!annotationView) {
            annotationView = [[MGLAnnotationView alloc] initWithReuseIdentifier:reuseIdentifier];
            annotationView.frame = CGRectMake(0, 0, 20, 20);
            annotationView.layer.masksToBounds = NO;
            annotationView.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
            
            UIImage *image = [UIImage imageNamed:@"marker"];
            image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
            imageView.image = image;
            imageView.contentMode = UIViewContentModeCenter;
            
            [annotationView addSubview:imageView];
        }
        
        CGFloat degrees = fabs(180.0f - self.cachedHeading.trueHeading);
        annotationView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degrees/360.0f * M_PI);

        self.currentPointView = annotationView;
        return annotationView;
    }
    
    // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%f", annotation.coordinate.longitude];
    
    // For better performance, always try to reuse existing annotations.
    MGLAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    // If there’s no reusable annotation view available, initialize a new one.
    if (!annotationView) {
        annotationView = [[MGLAnnotationView alloc] initWithReuseIdentifier:reuseIdentifier];
        annotationView.frame = CGRectMake(0, 0, 20, 20);

        UIImage *image = [UIImage imageNamed:@"testMarker"];
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.layer.cornerRadius = 10.0f;
        imageView.layer.masksToBounds = YES;
        imageView.image = image;
        [annotationView addSubview:imageView];
        
        annotationView.layer.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        [self addScaleForView:annotationView];
    }
    
    return annotationView;
}

- (void)addScaleForView:(UIView *)view
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = 0.2f;
    scale.autoreverses = NO;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.removedOnCompletion = YES;
    scale.fromValue = [NSNumber numberWithFloat:0.0f];
    scale.toValue = [NSNumber numberWithFloat:1.0f];
    [view.layer addAnimation:scale forKey:@"fuck"];
}

// Allow callout view to appear when an annotation is tapped.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
