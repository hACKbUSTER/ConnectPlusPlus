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
#import "CreateTextViewController.h"
#import "TagManageTableView.h"
#import "NetworkManager.h"
#import "Storage.h"
#import "DefaultsManager.h"

@import Mapbox;


@interface ViewController () <MGLMapViewDelegate,UIViewControllerPreviewingDelegate>
{
    // Timer for 轮询
    NSTimer *requestTimer;
    
    UIImageView *profileImageView;
    
    NSInteger maxMarkerCount;
}

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic)         CLLocationCoordinate2D currentLocation;
@property (nonatomic)         MGLCoordinateBounds currentVisibleBounds;
@property (nonatomic, strong) MGLPointAnnotation *currentUserAnnotation;

@property (nonatomic, strong) NSMutableArray *markerArray;

// Annotation views
@property (nonatomic, strong) NSMutableArray *markerViewArray;

@property (nonatomic, strong) UIView *bottomToolBarView;

@property (nonatomic, strong) UIButton *bottomToolBarCameraButton;
@property (nonatomic, strong) UIButton *bottomToolBarMicroButton;

@property (nonatomic, strong) UIButton *topBarListButton;
@property (nonatomic, strong) UIButton *topBarAddTagButton;

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UILabel *topBarTitleView;

@property (nonatomic, strong) MGLAnnotationView *currentPointView;
@property (nonatomic, strong) CLHeading *cachedHeading;

@property (nonatomic, strong) TagManageTableView *tagTableView;

// Message Points
@property (nonatomic, strong) NSMutableArray *messagePoints;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    maxMarkerCount = 100;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _markerArray = [NSMutableArray array];
    _markerViewArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *styleURL = [NSURL URLWithString:@"mapbox://styles/sergiochan/ciuaw89t4001p2io9pvhfsk3p"];
    _mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:styleURL];
    _mapView.tintColor = [UIColor whiteColor];

    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Set the delegate property of our map view to `self` after instantiating it.
    _mapView.delegate = self;

    _mapView.userTrackingMode = MGLUserTrackingModeFollowWithHeading;
    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = NO;
    _mapView.rotateEnabled = NO;
    _mapView.pitchEnabled = NO;
    _mapView.zoomLevel = 15.0f;
    
    [self.view addSubview:_mapView];
    
//    UIView *view = [_mapView viewForAnnotation:_mapView.userLocation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_mapView addGestureRecognizer:tap];
    
    _bottomToolBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, ScreenHeight - 55.0f, ScreenWidth, 55.0f)];
    _bottomToolBarView.backgroundColor = [UIColor blackColor];
    
    _bottomToolBarCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 110.0f, 7.5f, 40.0f, 40.0f)];
    _bottomToolBarCameraButton.backgroundColor = [UIColor clearColor];
    [_bottomToolBarCameraButton setImage:[UIImage imageNamed:@"camera1"] forState:UIControlStateNormal];
    [_bottomToolBarCameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBarView addSubview:_bottomToolBarCameraButton];
    
    _bottomToolBarMicroButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50.0f, 7.5f, 40.0f, 40.0f)];
    _bottomToolBarMicroButton.backgroundColor = [UIColor clearColor];
    [_bottomToolBarMicroButton setImage:[UIImage imageNamed:@"micphone"] forState:UIControlStateNormal];
    [_bottomToolBarMicroButton addTarget:self action:@selector(microButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBarView addSubview:_bottomToolBarMicroButton];
    
    [self.view addSubview:_bottomToolBarView];
    
    [self initTopBarView];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    self.tagTableView = [[TagManageTableView alloc] initWithFrame:CGRectMake(0.0f, -(ScreenHeight - _topBarView.height), ScreenWidth, ScreenHeight - _topBarView.height)];

    [self.view addSubview:_tagTableView];
    
    requestTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(requestUpdate) userInfo:nil repeats:YES];
}

- (void)initTopBarView
{
    _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 80.0f)];
    _topBarView.backgroundColor = [UIColor clearColor];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithFrame:_topBarView.bounds];
    blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    [_topBarView addSubview:blurView];
    
    _topBarListButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 52.0f, 25.5f, 50.0f, 50.0f)];
    _topBarListButton.backgroundColor = [UIColor clearColor];
    [_topBarListButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [_topBarListButton addTarget:self action:@selector(barListButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_topBarView addSubview:_topBarListButton];
    
    _topBarTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 200.0f, 40.0f)];
    _topBarTitleView.text = @"Connect ++";
    _topBarTitleView.textColor = [UIColor whiteColor];
    _topBarTitleView.font = [UIFont fontWithName:@"TT Cottons Light DEMO" size:30.0f];
    _topBarTitleView.textAlignment = NSTextAlignmentCenter;
    _topBarTitleView.center = CGPointMake(_topBarView.center.x, _topBarTitleView.center.y);
    
    [_topBarView addSubview:_topBarTitleView];
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 35.0f, 30.0f, 30.0f)];
    profileImageView.image = [UIImage imageNamed:@"Profile"];
    profileImageView.layer.cornerRadius = 15.0f;
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImageView.layer.borderWidth = 1.0f;
    
    [_topBarView addSubview:profileImageView];
    
    self.topBarAddTagButton = [[UIButton alloc] initWithFrame:CGRectMake(2.0f, 25.0f, 50.0f, 50.0f)];
    _topBarAddTagButton.backgroundColor = [UIColor clearColor];
    [_topBarAddTagButton setImage:[UIImage imageNamed:@"addTag"] forState:UIControlStateNormal];
    [_topBarAddTagButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _topBarAddTagButton.alpha = 0.0f;
    _topBarAddTagButton.hidden = YES;
    
    [_topBarView addSubview:_topBarAddTagButton];
    
    [self.view addSubview:_topBarView];
}

#pragma mark - Timer Methods

- (void)requestUpdate
{
    // Execute per second
    //[self addingFakeMessages];
    [self getAndRenderPoints];
}

#pragma mark - Update Message Points

- (void)getAndRenderPoints
{
    if (_messagePoints == nil)
    {
        _messagePoints = [[NSMutableArray alloc] init];
    }
    
    // Generate Bounds
    NSDictionary *lowerLeft = @{
                                @"longtitude": [NSNumber numberWithDouble:_currentVisibleBounds.sw.longitude],
                                @"latitude": [NSNumber numberWithDouble:_currentVisibleBounds.sw.latitude]
                                };
    NSDictionary *upperRight = @{
                                 @"longtitude": [NSNumber numberWithDouble:_currentVisibleBounds.ne.longitude],
                                 @"latitude": [NSNumber numberWithDouble:_currentVisibleBounds.ne.latitude]
                                 };
    
    [Storage getMessages:lowerLeft withUpperRight:upperRight andTags:nil andCallback:^(NSArray *messages) {
        for (NSDictionary *message in messages) {
            BOOL flag = NO;
            NSString *tmp = message[@"objectId"];
            NSUInteger size = [_messagePoints count];
            for (int i = 0; i < size; i++) {
                NSString *t = _messagePoints[i][@"objectId"];
                if ([tmp isEqualToString:t])
                {
                    flag = YES;
                    break;
                }
            }
            if (flag == NO)
            {
//                NSString *categorieString = [self generateCategorieString:message[@"tags"]];
                NSString *mainTag = [message[@"tags"] objectAtIndex:0]; //@"TAG";//TODO
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                [self addNewMarkerAtCoordinate:CLLocationCoordinate2DMake([message[@"latitude"] doubleValue], [message[@"longtitude"] doubleValue]) message:jsonStr mainTag:mainTag];
                
                [_messagePoints addObject:message];
            }
        }
        NSLog(@"yangsiyu-rendered-count: %lu", (unsigned long)[_messagePoints count]);
    }];
}

- (NSString *)generateCategorieString:(NSArray *)tags
{
    NSString *rtn = @"";
    for (NSString *tag in tags) {
        rtn = [NSString stringWithFormat:@"%@#%@", rtn, tag];
    }
    return rtn;
}

- (void)addingFakeMessages
{
    NSArray *tags1 = @[@"aaa", @"bbb", @"ccc"];
    //float longtitude = [self randomFloatBetween:_mapView.visibleCoordinateBounds.sw.longitude andLargerFloat:_mapView.visibleCoordinateBounds.ne.longitude];
    //float latitude = [self randomFloatBetween:_mapView.visibleCoordinateBounds.sw.latitude andLargerFloat:_mapView.visibleCoordinateBounds.ne.latitude];
    
    CGFloat latitude_delta = fabs(_mapView.visibleCoordinateBounds.ne.latitude - _mapView.visibleCoordinateBounds.sw.latitude) * 0.5f;
    CGFloat longitude_delta = fabs(_mapView.visibleCoordinateBounds.ne.longitude - _mapView.visibleCoordinateBounds.sw.longitude) * 0.5f;
    
    CLLocationCoordinate2D t = CLLocationCoordinate2DMake(self.currentLocation.latitude - latitude_delta/2.0f + [self randomFloatBetween:0.0f andLargerFloat:1.0f] * latitude_delta,self.currentLocation.longitude - longitude_delta/2.0f + [self randomFloatBetween:0.0f andLargerFloat:1.0f] * longitude_delta);
    
    [Storage saveTextMessage:@"test message" withLongtitude:t.longitude andLatitude:t.latitude andTags:tags1];
    //longtitude = [self randomFloatBetween:_mapView.visibleCoordinateBounds.sw.longitude andLargerFloat:_mapView.visibleCoordinateBounds.ne.longitude];
    //latitude = [self randomFloatBetween:_mapView.visibleCoordinateBounds.sw.latitude andLargerFloat:_mapView.visibleCoordinateBounds.ne.latitude];
    //[Storage saveImageMessage:[UIImage imageNamed:@"Profile"] withFilename:@"test.jpg" andLongtitude:longtitude andLatitude:latitude andTags:tags1];
}

#pragma mark - For test creation

- (float)randomFloatBetween:(float)num1 andLargerFloat:(float)num2
{
    int startVal = num1*10000;
    int endVal = num2*10000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a /10000.0);
}

- (void)addNewMarkerAtCoordinate:(CLLocationCoordinate2D)coordinate message:(NSString *)categorieString mainTag:(NSString *)mainTag
{
    MGLPointAnnotation *testMarker = [[MGLPointAnnotation alloc] init];
    testMarker.coordinate = coordinate;
    testMarker.title = mainTag;
    testMarker.subtitle = categorieString;
    
    [self.mapView addAnnotation:testMarker];
    [_markerArray addObject:testMarker];
    if (_markerArray.count > maxMarkerCount) {
        [self.mapView removeAnnotation:[_markerArray objectAtIndex:0]];
        [_markerArray removeObjectAtIndex:0];
    }
}

- (void)tap:(UIGestureRecognizer *)gesture
{
//    MGLPointAnnotation *testMarker = [[MGLPointAnnotation alloc] init];
//    
//    CGFloat latitude_delta = fabs(_mapView.visibleCoordinateBounds.ne.latitude - _mapView.visibleCoordinateBounds.sw.latitude) * 0.5f;
//    CGFloat longitude_delta = fabs(_mapView.visibleCoordinateBounds.ne.longitude - _mapView.visibleCoordinateBounds.sw.longitude) * 0.5f;
//    
//    CLLocationCoordinate2D t = CLLocationCoordinate2DMake(self.currentLocation.latitude - latitude_delta/2.0f + [self randomFloatBetween:0.0f andLargerFloat:1.0f] * latitude_delta,self.currentLocation.longitude - longitude_delta/2.0f + [self randomFloatBetween:0.0f andLargerFloat:1.0f] * longitude_delta);
//    testMarker.coordinate = t;
//    testMarker.title = @"TAG";
//    testMarker.subtitle = [NSString stringWithFormat:@"traffic/indooractivity%ld",_markerArray.count];
//    
//    [self.mapView addAnnotation:testMarker];
//    [_markerArray addObject:testMarker];
//    if (_markerArray.count > maxMarkerCount) {
//        [self.mapView removeAnnotation:[_markerArray objectAtIndex:0]];
//        [_markerArray removeObjectAtIndex:0];
//    }
//    [self addingFakeMessages];
}

- (void)addButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldAddTag" object:nil];
}

- (void)barListButtonPressed:(id)sender
{
    if (_topBarView.top > 100.0f) {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _topBarView.top = 0.0f;
            _tagTableView.top = -(ScreenHeight - _topBarView.height);
            profileImageView.alpha = 1.0f;
            _topBarAddTagButton.alpha = 0.0f;
            _bottomToolBarView.top = ScreenHeight - _bottomToolBarView.height;
        } completion:^(BOOL finished) {
            _topBarAddTagButton.hidden = YES;
        }];
    } else {
        _topBarAddTagButton.hidden = NO;
        _topBarAddTagButton.alpha = 0.0f;
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _topBarView.top = ScreenHeight - _topBarView.height;
            _tagTableView.top = 0.0f;
            profileImageView.alpha = 0.0f;
            _topBarAddTagButton.alpha = 1.0f;
            _bottomToolBarView.top = ScreenHeight;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)cameraButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"CallCamera" sender:self];
}

- (void)microButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"CallMicrophone" sender:self];
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location
{
    for (MGLAnnotationView *annotationView in self.markerViewArray)
    {
        if (annotationView) {
            if ([annotationView.layer containsPoint:[self.mapView.layer convertPoint:location toLayer:annotationView.layer]])
            {
                NSInteger index = [self.markerViewArray indexOfObject:annotationView];
                MGLPointAnnotation *t = [self.markerArray objectAtIndex:index];
                
                NSData* data1 = [t.subtitle dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
                
                PointPeekViewController *peek = [[PointPeekViewController alloc] init];
                peek.messageDict = messageDict;
                
                peek.view.frame = self.view.frame;
                
                return peek;
            }
        }
    }
    
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - MGLMapViewDelegate Methods

- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(nullable MGLUserLocation *)userLocation
{
    [[DefaultsManager sharedManager] setCurrentLocation:userLocation.location.coordinate];
    self.currentLocation = userLocation.location.coordinate;
    NSLog(@"***** %f",userLocation.heading.trueHeading);
}

// 这里是所见区域更新的回调方法，需要在这里重新请求界面上的数据点
- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    _currentVisibleBounds = mapView.visibleCoordinateBounds;
//    
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((mapView.visibleCoordinateBounds.ne.latitude + mapView.visibleCoordinateBounds.sw.latitude)/2.0f, (mapView.visibleCoordinateBounds.ne.longitude + mapView.visibleCoordinateBounds.sw.longitude)/2.0f);
    
//    NSLog(@"regionDidChange! ");
}


- (void)mapViewDidFinishRenderingFrame:(MGLMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (fullyRendered) {
    }
}

- (void)mapView:(nonnull MGLMapView *)mapView didSelectAnnotation:(nonnull id<MGLAnnotation>)annotation
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
    NSString *imageName = @"point_default";
    if ([item.title isEqualToString:@"weather"]) {
        imageName = @"point_cloud";
    } else if ([item.title isEqualToString:@"traffic"]) {
        imageName = @"point_car";
    } else if ([item.title isEqualToString:@"sports"]) {
        imageName = @"point_sport";
    }
    
    // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%f", annotation.coordinate.longitude];
    
    // For better performance, always try to reuse existing annotations.
    MGLAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    // If there’s no reusable annotation view available, initialize a new one.
    if (!annotationView) {
        annotationView = [[MGLAnnotationView alloc] initWithReuseIdentifier:reuseIdentifier];
        annotationView.frame = CGRectMake(0, 0, 30, 30);

        UIImage *image = [UIImage imageNamed:imageName];
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.layer.cornerRadius = 15.0f;
        imageView.layer.masksToBounds = YES;
        imageView.image = image;
        [annotationView addSubview:imageView];
        
        annotationView.layer.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        [self addScaleForView:annotationView];
        
        [_markerViewArray addObject:annotationView];
        if (_markerViewArray.count > maxMarkerCount) {
            [self.mapView removeAnnotation:[_markerViewArray objectAtIndex:0]];
            [_markerViewArray removeObjectAtIndex:0];
        }
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
