//
//  TagManageTableView.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/15.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "TagManageTableView.h"
#import "UIView+ViewFrameGeometry.h"
#import "TagTableViewCell.h"

@interface TagManageTableView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UITableView *tagTableView;

@end

@implementation TagManageTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.blurView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
        _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        [self addSubview:_blurView];
        
        self.tagTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height) style:UITableViewStylePlain];
        self.tagTableView.delegate = self;
        self.tagTableView.dataSource = self;
        self.tagTableView.backgroundColor = [UIColor clearColor];
        self.tagTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tagTableView];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
@end
