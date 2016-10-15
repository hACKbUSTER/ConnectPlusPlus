//
//  PointPeekViewController.h
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/15.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointPeekViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *tagTextView;
@property (weak, nonatomic) IBOutlet UIView *connetContentView;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (nonatomic, strong) NSDictionary *messageDict;

@end
