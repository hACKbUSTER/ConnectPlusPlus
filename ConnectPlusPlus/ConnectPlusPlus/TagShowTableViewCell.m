//
//  TagShowTableViewCell.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "TagShowTableViewCell.h"
#import "tagShowButton.h"

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
    [self processHyperLinks];
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
    for (UIView *subView in self.hyperLinksScrollView.subviews)
    {
        [subView removeFromSuperview];
    }

    NSDictionary *dict = [self hyperLinksDict];
    NSMutableArray *btnsArray = [NSMutableArray array];
    for (NSString *key in dict)
    {
        NSLog(@"key: %@ value: %@", key, dict[key]);
        CGSize textSize = [key sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
        CGFloat strikeWidth = textSize.width;
        tagShowButton *btn = [[tagShowButton alloc] initWithFrame:CGRectMake(0, 0, strikeWidth + 12.0f, 30)];
        [btn setTitle:key forState:UIControlStateNormal];
    
        btn.thefuckingURL = [[NSString stringWithFormat:@"%@%@",dict[key],self.tagString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self setBackgroundImageStretchableForState:UIControlStateNormal Button:btn Image:[UIImage imageNamed:@"roundedStretchable"]];
        [btn addTarget:self action:@selector(openurlStuff:) forControlEvents:UIControlEventTouchUpInside];
        [btnsArray addObject:btn];
    }
    
//    self.hyperLinksScrollView.contentSize = 
    CGSize size = CGSizeMake(0, 27.0f);
    float xflag = 0.0f;
    for (int i = 0; i < btnsArray.count; i++)
    {
        tagShowButton *btn = btnsArray[i];
        float nextFlagDistance=btn.frame.size.width + 6.0f;;
        size.width += nextFlagDistance;
        btn.frame = CGRectMake(xflag, 0, btn.frame.size.width, btn.frame.size.height);
        [_hyperLinksScrollView addSubview:btn];
        xflag += nextFlagDistance;
    }
}

- (void)openurlStuff: (tagShowButton *)sender
{
    [sender openthefuckingURL];
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

- (NSDictionary *)hyperLinksDict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"https://www.baidu.com/s?wd=",@"Baidu",
            @"https://www.google.com.hk/#&q=",@"Google",
            @"https://zh.wikipedia.org/wiki/",@"Wikipedia"
            ,nil];
}
@end
