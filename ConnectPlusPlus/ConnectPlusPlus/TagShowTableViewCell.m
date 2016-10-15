//
//  TagShowTableViewCell.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "TagShowTableViewCell.h"

@implementation TagShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTagString:(NSString*)tagString
{
    _tagString = tagString;
    [self.tagLabel setText: [NSString stringWithFormat:@"# %@",_tagString]];
    [self setIsAdded:NO];
}

- (void)setIsAdded:(BOOL)isAdded;
{
    _isAdded = isAdded;
    if (isAdded)
    {
        [self.addMinusTagButton setImage:[UIImage imageNamed:@"minusRoundButton"] forState:UIControlStateNormal];
    }else
    {
        [self.addMinusTagButton setImage:[UIImage imageNamed:@"addRoundButton"] forState:UIControlStateNormal];
    }
}
- (IBAction)addMinusButtonPressed:(id)sender
{
    [self setIsAdded:!self.isAdded];
}

- (void)processHyperLinks
{
    
}

- (void)setBackgroundImageStretchableForState:(UIControlState)controlState
                                       Button:(UIButton *)button
                                        Image:(UIImage *)image
{
    if (image)
    {
        CGFloat capWidth =  floorf(image.size.width / 2);
        CGFloat capHeight =  floorf(image.size.height / 2);
        UIImage *capImage = [image resizableImageWithCapInsets:
                             UIEdgeInsetsMake(capHeight, capWidth, capHeight, capWidth)];
        
        [button setBackgroundImage:capImage forState:controlState];
    }
}

@end
