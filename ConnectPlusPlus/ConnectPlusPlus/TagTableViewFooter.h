//
//  TagTableViewFooter.h
//  ConnectPlusPlus
//
//  Created by Cee on 16/10/2016.
//  Copyright © 2016 hackbuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagTableViewFooterDelegate <NSObject>

- (void)didEndInputWithTextField:(UITextField *)textField;
@end

@interface TagTableViewFooter : UIView
@property (nonatomic, weak) id<TagTableViewFooterDelegate> delegate;
- (void)show;
- (void)hide;
@end
