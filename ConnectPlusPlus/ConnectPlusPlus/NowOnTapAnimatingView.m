//
//  NowOnTapAnimatingView.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#define NOW_ON_TAP_BUTTONS_HEIGHT 74

#import "NowOnTapAnimatingView.h"
#import <QuartzCore/QuartzCore.h>
#import "TagShowTableView.h"



@interface NowOnTapAnimatingView ()

@property (nonatomic,strong) UIVisualEffectView *visualEffectView;
@property (nonatomic,strong) TagShowTableView *tagTableView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *confirmButton;

@end

@implementation NowOnTapAnimatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.0f;
    _hasAnimated = NO;
    
    
    return self;
}

- (void)didMoveToSuperview
{
    if (_hasAnimated)
    {
        return;
    }
    //animating
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.window.bounds.size);
    }
    
    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.alpha = 1.0f;
    
    if (image)
    {
        _screenshotView = [[UIImageView alloc] initWithFrame:self.frame];
        _screenshotView.image = image;
        [self addSubview:_screenshotView];
    }
    
    CGRect currentFrame = self.frame;
    [UIView animateWithDuration:0.4f animations:^(void)
    {
        float scale = 0.97f;
        CGRect scaledRect = CGRectMake(self.frame.size.width * (1.0f - scale)/ 2.0f, self.frame.size.height * (1.0f - scale)/ 2.0f, self.frame.size.width * scale, self.frame.size.height * scale);
        _screenshotView.frame = scaledRect;
        self.backgroundColor = [UIColor whiteColor];
    }
completion:^(BOOL fin)
    {
        [UIView animateWithDuration:0.5f animations:^(void)
         {
             _screenshotView.frame = currentFrame;
             self.backgroundColor = [UIColor blackColor];
             
             UIVisualEffect *blurEffect;
             blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
             _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
             _visualEffectView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height/2);
             
             _tagTableView = [[TagShowTableView alloc] initWithFrame:CGRectMake(0, 0, _visualEffectView.frame.size.width, _visualEffectView.frame.size.height - NOW_ON_TAP_BUTTONS_HEIGHT)];
             _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _visualEffectView.frame.size.height - NOW_ON_TAP_BUTTONS_HEIGHT,  _visualEffectView.frame.size.width/2, NOW_ON_TAP_BUTTONS_HEIGHT)];
             [_cancelButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
             _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(_visualEffectView.frame.size.width/2, _visualEffectView.frame.size.height - NOW_ON_TAP_BUTTONS_HEIGHT,  _visualEffectView.frame.size.width/2, NOW_ON_TAP_BUTTONS_HEIGHT)];
             [_confirmButton setImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
             
             [_visualEffectView addSubview:_tagTableView];
             [_visualEffectView addSubview:_cancelButton];
             [_visualEffectView addSubview:_confirmButton];
             
             
         }completion:^(BOOL fin)
         {
             [self addSubview:_visualEffectView];
             [UIView animateWithDuration:0.5f animations:^(void)
              {
                  _visualEffectView.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
              }];
         }];
    }];
    
    _hasAnimated = YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
