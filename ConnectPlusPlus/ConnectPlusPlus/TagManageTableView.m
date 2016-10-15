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
#import "DefaultsManager.h"
#import "TagTableViewFooter.h"

@interface TagManageTableView() <UITableViewDelegate, UITableViewDataSource, TagTableViewFooterDelegate>
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UITableView *tagTableView;
@property (nonatomic, strong) TagTableViewFooter *footerView;
@end

@implementation TagManageTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.models = [[DefaultsManager sharedManager] getTags];
        self.blurView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
        _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        [self addSubview:_blurView];
        
        self.tagTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height) style:UITableViewStylePlain];
        self.tagTableView.delegate = self;
        self.tagTableView.dataSource = self;
        self.tagTableView.backgroundColor = [UIColor clearColor];
        self.tagTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tagTableView.allowsSelection = NO;
        self.tagTableView.allowsMultipleSelectionDuringEditing = NO;
        [self addSubview:self.tagTableView];
        self.footerView = [[TagTableViewFooter alloc] initWithFrame:CGRectMake(0, 0, self.width, 108)];
        self.footerView.alpha = 0;
        self.footerView.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFooter) name:@"shouldAddTag" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 108.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setupWithTagString:self.models[indexPath.row]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *tagString = self.models[indexPath.row];
        [[DefaultsManager sharedManager] deleteTag:tagString];
        self.models = [[DefaultsManager sharedManager] getTags];
        [self.tagTableView reloadData];
    }
}

#pragma mark - FooterViewDelegate
- (void)didEndInputWithTextField:(UITextField *)textField {
    NSString *tagString = textField.text;
    [[DefaultsManager sharedManager] addTag:tagString];
    self.models = [[DefaultsManager sharedManager] getTags];
    [self.tagTableView reloadData];
}

- (void)showFooter {
    [self.footerView show];
}
@end
