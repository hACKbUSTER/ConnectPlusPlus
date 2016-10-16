//
//  TagShowTableView.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "TagShowTableView.h"
#import "TagShowTableViewCell.h"
#import "NetworkManager.h"

@interface TagShowTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIActivityIndicatorView * loadingIndicator;
@end

@implementation TagShowTableView
- (id) initWithFrame:(CGRect)frame NowOnTap:(NowOnTapAnimatingView *)view
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tagsData = [NSMutableArray array];
        self.categoriesData = [NSMutableArray array];
        
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor clearColor];
        self.allowsSelection = NO;
        [self registerNib:[UINib nibWithNibName:@"TagShowTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TagShowTableViewCell"];
        self.delegate = self;
        self.dataSource = self;
        
        _loadingIndicator = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingIndicator.frame = CGRectMake(0, 0, 40, 40);
        _loadingIndicator.center = self.center;
//        [_loadingIndicator startAnimating];
                _loadingIndicator.hidesWhenStopped = YES;
        [self addSubview:_loadingIndicator];
        
        
        self.nowOnTapView = view;
        
        
        // NETWORK TASK
        if (self.nowOnTapView.sourceImage)
        {
            [_loadingIndicator startAnimating];
            [[NetworkManager sharedManager] getJSONWithImageData:UIImageJPEGRepresentation(self.nowOnTapView.sourceImage, 0.7f) success:^(id obj)
             {
                 _tagsData = [obj objectForKey:@"tags"];
                 _categoriesData = [obj objectForKey:@"categories"];
                 if (_tagsData || _categoriesData)
                 {
                     [_loadingIndicator stopAnimating];
                     [self reloadData];
                 }
             } failure:^(NSError *err)
             {
                 //WHO CARES ERROR
               NSLog(@"%@",err.debugDescription);
             }];
        }else if (self.nowOnTapView.sourceText)
        {
            
        }
    }
    return self;
}

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
    
    NSString *tag = @"";
    
    if (_tagsData == nil && _categoriesData == nil)
    {
        
    }
    else if (_tagsData != nil && _categoriesData == nil)
    {
        tag = [[_tagsData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    else if (_tagsData == nil && _categoriesData != nil)
    {
        tag = [[_categoriesData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    else
    {
        tag = indexPath.row < _tagsData.count ?  [[_tagsData objectAtIndex:indexPath.row] objectForKey:@"name"] :  [[_categoriesData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }

    

//    NSString *tag = [[_tagsData objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell setTagString:tag];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return (_tagsData == nil? 0 : _tagsData.count) + (_categoriesData == nil? 0 : _categoriesData.count);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
