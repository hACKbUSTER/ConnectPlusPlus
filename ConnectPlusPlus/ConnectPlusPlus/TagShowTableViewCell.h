//
//  TagShowTableViewCell.h
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *addMinusTagButton;
@property (weak, nonatomic) IBOutlet UIScrollView *hyperLinksScrollView;

@property (strong, nonatomic, setter=setTagString:) NSString *tagString;
@property (nonatomic, setter=setIsAdded:) BOOL isAdded;

- (void)setTagString:(NSString*)tagString;
- (void)setIsAdded:(BOOL)isAdded;


@end
