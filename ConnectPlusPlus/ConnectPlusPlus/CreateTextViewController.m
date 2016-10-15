//
//  CreateTextViewController.m
//  ConnectPlusPlus
//
//  Created by Fincher Justin on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "CreateTextViewController.h"

@interface CreateTextViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation CreateTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.inputTextView.delegate = self;
    [_inputTextView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        // 跳转 Now On Tap
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
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
