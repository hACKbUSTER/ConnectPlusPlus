//
//  TagTableViewCell.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "TagTableViewCell.h"
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>
#import "UIView+ViewFrameGeometry.h"
#import "NetworkManager.h"

@interface TagTableViewCell()
@property (nonatomic, strong) NSString *tagString;
@property (nonatomic, strong) YYAnimatedImageView *backgroundImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TagTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.maskView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTagString:(NSString *)tagString {
    if ([_tagString isEqualToString:tagString]) {
        return ;
    }
    _tagString = tagString;
    self.backgroundImageView.image = nil;
    self.titleLabel.text = [NSString stringWithFormat:@"#%@", tagString];
    [[NetworkManager sharedManager] getImageFromBingWithString:tagString success:^(id object) {
        [self.backgroundImageView yy_setImageWithURL:[NSURL URLWithString:object] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            return image;
        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
        }];
    } failure:^(NSError *error) {
        self.backgroundImageView.backgroundColor = [UIColor colorWithRed:216.f/255.f green:216.f/255.f blue:216.f/255.f alpha:1.f];
    }];
    
}

- (void)layoutSubviews
{
    
}

#pragma mark - Init
- (YYAnimatedImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 108)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.layer.masksToBounds = YES;
        _backgroundImageView.userInteractionEnabled = NO;
    }
    return _backgroundImageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 108)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .6f;
    }
    return _maskView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 43, ScreenWidth - 40, 36)];
        _titleLabel.font = [UIFont systemFontOfSize:30.f weight:UIFontWeightHeavy];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
@end
