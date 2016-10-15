//
//  TagShowTableView.h
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowOnTapAnimatingView.h"

@interface TagShowTableView : UITableView

@property (weak) NowOnTapAnimatingView *nowOnTapView;
- (id) initWithFrame:(CGRect)frame NowOnTap:(NowOnTapAnimatingView *)view;

@end
