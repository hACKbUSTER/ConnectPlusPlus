//
//  TagShowTableView.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "TagShowTableView.h"
#import "TagShowTableViewCell.h"

@interface TagShowTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TagShowTableView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor clearColor];
        self.allowsSelection = NO;
        [self registerNib:[UINib nibWithNibName:@"TagShowTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TagShowTableViewCell"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDelegate]
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112.0f;
}

#pragma  mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagShowTableViewCell"];
    [cell setTagString:@"Apple"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
