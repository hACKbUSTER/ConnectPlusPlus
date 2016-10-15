//
//  MicrophoneViewController.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "MicrophoneViewController.h"
#import <Waver/Waver.h>
#import "UIView+ViewFrameGeometry.h"
#import "VoiceKit.h"
#import "NowOnTapAnimatingView.h"

@interface MicrophoneViewController ()

@property (nonatomic, strong) Waver * waver;

@property (nonatomic, strong) UIButton *captureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation MicrophoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.waver = [[Waver alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)/2.0 - 50.0, CGRectGetWidth(self.view.bounds), 100.0)];
    
    self.waver.waverLevelCallback = ^() {
        
        //        [self.recorder updateMeters];
        
        //        CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 50);
        //
        //        weakWaver.level = normalizedValue;
        
    };
    [self.view addSubview:_waver];
    self.waver.level = 0.0f;
    
    [VoiceKit sharedInstance].successBlock = ^(id object)
    {
        NSLog(@"FUCKKKKK %@",object);
        NowOnTapAnimatingView *nowOnTapView = [[NowOnTapAnimatingView alloc] initWithFrame:self.view.frame];
        nowOnTapView.sourceText = (NSString *)object;
        [self.view addSubview:nowOnTapView];

    };
    
    [VoiceKit sharedInstance].volumeChangeBlock = ^(int volume) {
        self.waver.level =  pow (20, volume / 50);
    };
    
    self.captureButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2.0f - 30.0f, ScreenHeight - 90.0f, 60.0f, 60.0f)];
    [_captureButton setBackgroundColor:[UIColor whiteColor]];
    _captureButton.layer.cornerRadius = 30.0f;
    _captureButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _captureButton.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    _captureButton.layer.shadowOpacity = 0.7f;
    _captureButton.layer.shadowRadius = 10.0f;
    [_captureButton addTarget:self action:@selector(captureBegin:) forControlEvents:UIControlEventTouchDown];
    [_captureButton addTarget:self action:@selector(captureEnd:) forControlEvents:UIControlEventTouchUpInside];
    [_captureButton addTarget:self action:@selector(captureCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_captureButton];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 120.0f, ScreenHeight - 70.0f, 80.0f, 20.0f)];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"TT Cottons Light DEMO" size:20.0f];
    [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    // Do any additional setup after loading the view.
}

- (void)captureBegin:(id)sender
{
    [[VoiceKit sharedInstance] startListening];
    [_captureButton setBackgroundColor:[UIColor redColor]];
}

- (void)captureEnd:(id)sender
{
    [[VoiceKit sharedInstance] endListening];
    [_captureButton setBackgroundColor:[UIColor whiteColor]];
    self.waver.level = 0;
}

- (void)captureCancel:(id)sender
{
    [[VoiceKit sharedInstance] cancelListening];
    [_captureButton setBackgroundColor:[UIColor whiteColor]];
    self.waver.level = 0;
}

- (void)cancel:(id)sender
{
    [[VoiceKit sharedInstance] cancelListening];
    [_captureButton setBackgroundColor:[UIColor whiteColor]];
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
