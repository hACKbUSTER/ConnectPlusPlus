//
//  CameraViewController.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/15.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "CameraViewController.h"
#import <LLSimpleCamera.h>
#import "UIView+ViewFrameGeometry.h"
#import "NowOnTapAnimatingView.h"

@interface CameraViewController ()

@property (nonatomic, strong) LLSimpleCamera *camera;

@property (nonatomic, strong) UIImageView *previewImageView;

@property (nonatomic, strong) UIButton *captureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // create camera with standard settings
    self.camera = [[LLSimpleCamera alloc] init];
    
    // camera with video recording capability
    self.camera =  [[LLSimpleCamera alloc] initWithVideoEnabled:NO];
    
    // camera with precise quality, position and video parameters.
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
    // attach to the view
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
            }
        }
    }];

    self.captureButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2.0f - 30.0f, ScreenHeight - 90.0f, 60.0f, 60.0f)];
    [_captureButton setBackgroundColor:[UIColor whiteColor]];
    _captureButton.layer.cornerRadius = 30.0f;
    _captureButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _captureButton.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    _captureButton.layer.shadowOpacity = 0.7f;
    _captureButton.layer.shadowRadius = 10.0f;
    [_captureButton addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_captureButton];
    
    self.previewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_previewImageView];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 120.0f, ScreenHeight - 70.0f, 80.0f, 20.0f)];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"TT Cottons Light DEMO" size:20.0f];
    [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.camera start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.camera stop];
}

- (void)capture:(id)sender
{
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            // We should stop the camera, we are opening a new vc, thus we don't need it anymore.
            // This is important, otherwise you may experience memory crashes.
            // Camera is started again at viewWillAppear after the user comes back to this view.
            // I put the delay, because in iOS9 the shutter sound gets interrupted if we call it directly.
            
//            [camera performSelector:@selector(stop) withObject:nil afterDelay:0.2];
            _previewImageView.alpha = 0.0f;
            _previewImageView.image = image;
            
            [UIView animateWithDuration:0.1f animations:^
            {
                _previewImageView.alpha = 1.0f;
                self.cancelButton.alpha = 0.0f;
            } completion:^(BOOL finished)
            {
                self.cancelButton.enabled = NO;
                [camera stop];
                // 请求 NetworkManager
                
                NowOnTapAnimatingView *nowOnTapView = [[NowOnTapAnimatingView alloc] initWithFrame:self.view.frame];
                nowOnTapView.sourceImage = image;
                [self.view addSubview:nowOnTapView];
            }];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
