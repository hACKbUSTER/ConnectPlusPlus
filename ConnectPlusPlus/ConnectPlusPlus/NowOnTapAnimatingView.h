//
//  NowOnTapAnimatingView.h
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol NowOnTapAnimatingViewDelegate <NSObject>
//@optional
//- (void)newTagDiscovered:(NSString *)tagName;
//@end
//

@interface NowOnTapAnimatingView : UIView

@property (atomic) BOOL hasAnimated;

@property (nonatomic,strong) UIImageView *screenshotView;
//@property (nonatomic, weak) id <NowOnTapAnimatingViewDelegate> delegate;

@end
