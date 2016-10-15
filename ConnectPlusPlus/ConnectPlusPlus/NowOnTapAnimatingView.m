//
//  NowOnTapAnimatingView.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "NowOnTapAnimatingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NowOnTapAnimatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
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
    
    if (image)
    {
        _screenshotView = [[UIImageView alloc] initWithFrame:self.frame];
        _screenshotView.image = image;
        [self addSubview:_screenshotView];
    }
    
    
    
    
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
