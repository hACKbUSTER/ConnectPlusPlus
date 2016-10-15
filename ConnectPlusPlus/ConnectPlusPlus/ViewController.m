//
//  ViewController.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/15.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "ViewController.h"
#import "AJLocationManager.h"
@import Mapbox;

@interface ViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic) MGLCoordinateBounds currentVisibleBounds;
@property (nonatomic, strong) MGLPointAnnotation *currentUserAnnotation;
@property (nonatomic, strong) NSMutableArray *markerArray;

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

    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = NO;
    _mapView.rotateEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    // Set the map’s center coordinate and zoom level.
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(59.31, 18.06)
                       zoomLevel:1 direction:0 animated:YES completionHandler:^{
                           weakSelf.currentUserAnnotation = [[MGLPointAnnotation alloc] init];
                           weakSelf.currentUserAnnotation.coordinate = weakSelf.currentLocation;
                           [weakSelf.mapView addAnnotation:weakSelf.currentUserAnnotation];
                           
                           [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                               weakSelf.currentLocation = CLLocationCoordinate2DMake(locationCorrrdinate.latitude, locationCorrrdinate.longitude);
                               [weakSelf.mapView setCenterCoordinate:weakSelf.currentLocation
                                                   zoomLevel:15
                                                    animated:YES];
                               weakSelf.currentUserAnnotation.coordinate = locationCorrrdinate;
                           }];
                       }];
    
    [self.view addSubview:_mapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_mapView addGestureRecognizer:tap];
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

#pragma mark - MGLMapViewDelegate Methods

// 这里是所见区域更新的回调方法，需要在这里重新请求界面上的数据点
- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    _currentVisibleBounds = mapView.visibleCoordinateBounds;
    
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((mapView.visibleCoordinateBounds.ne.latitude + mapView.visibleCoordinateBounds.sw.latitude)/2.0f, (mapView.visibleCoordinateBounds.ne.longitude + mapView.visibleCoordinateBounds.sw.longitude)/2.0f);
    
    NSLog(@"regionDidChange!");
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLPointAnnotation *item = (MGLPointAnnotation *)annotation;

    if ([item.title isEqualToString:@"TAG"]) {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        return nil;
    }
    
    // Try to reuse the existing ‘pisa’ annotation image, if it exists.
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"marker"];
    
    // If the ‘pisa’ annotation image hasn‘t been set yet, initialize it here.
    if (!annotationImage)
    {
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
        UIImage *image = [UIImage imageNamed:@"marker"];
        
        // The anchor point of an annotation is currently always the center. To
        // shift the anchor point to the bottom of the annotation, the image
        // asset includes transparent bottom padding equal to the original image
        // height.
        //
        // To make this padding non-interactive, we create another image object
        // with a custom alignment rect that excludes the padding.
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        
        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"marker"];
    }
    
    return annotationImage;
}

// Use the default marker. See also: our view annotation or custom marker examples.
- (nullable MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    
    MGLPointAnnotation *item = (MGLPointAnnotation *)annotation;
    
    if (![item.title isEqualToString:@"TAG"]) {
        return nil;
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
