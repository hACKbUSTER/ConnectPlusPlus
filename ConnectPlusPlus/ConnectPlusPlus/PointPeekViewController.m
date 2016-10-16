//
//  PointPeekViewController.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/15.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "PointPeekViewController.h"
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>

@interface PointPeekViewController ()

@end

@implementation PointPeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    BOOL hasImage = [[self.messageDict objectForKey:@"hasImage"] boolValue];
    if (hasImage)
    {
        NSString *url = [self.messageDict objectForKey:@"image"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.connetContentView.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.connetContentView addSubview:imageView];
//        imageView.layer.masksToBounds= YES;
        
        [imageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize)
        {
            
        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url)
        {
            return image;
        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error)
        {
            
        }];
    }else
    {
        NSString *text = [self.messageDict objectForKey:@"text"];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.connetContentView.frame.origin.x, 22.0f, self.connetContentView.frame.size.width, self.connetContentView.frame.size.height)];
        textView.text = [NSString stringWithFormat:@"\" %@ \"",text];
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:60.0f weight:100.0f];
        [self.connetContentView addSubview:textView];

    }
    
    NSArray *tags = [self.messageDict objectForKey:@"tags"];
    for (NSString *str in tags)
    {
        self.tagTextView.text = [self.tagTextView.text stringByAppendingString:[NSString stringWithFormat:@"#%@\n",str]];
    }
    
    
    
}
- (IBAction)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
