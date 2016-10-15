//
//  tagShowButton.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "tagShowButton.h"

@implementation tagShowButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)openthefuckingURL
{
    if (self.thefuckingURL)
    {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.thefuckingURL]];
    }
}

@end
