//
//  TagTableViewFooter.m
//  ConnectPlusPlus
//
//  Created by Cee on 16/10/2016.
//  Copyright © 2016 hackbuster. All rights reserved.
//

#import "TagTableViewFooter.h"
#import "UIView+ViewFrameGeometry.h"

@interface TagTableViewFooter () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation TagTableViewFooter

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.maskView];
        [self addSubview:self.textField];
    }
    return self;
}

#pragma mark - Init
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 108)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:216.f/255.f green:216.f/255.f blue:216.f/255.f alpha:1.f];
    }
    return _backgroundView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 108)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .6f;
    }
    return _maskView;
}


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 43, ScreenWidth - 40, 36)];
        _textField.font = [UIFont systemFontOfSize:30.f weight:UIFontWeightHeavy];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add a new tag" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:.5f]}];
        _textField.textColor = [UIColor whiteColor];
        _textField.delegate = self;
    }
    return _textField;
}

#pragma mark - Hide & Show
- (void)hide {
    [UIView animateWithDuration:.5f animations:^{
        self.alpha = 0.f;
    }];
}

- (void)show {
    self.textField.text = @"";
    [UIView animateWithDuration:.5f animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [self.textField becomeFirstResponder];
    }];
}

#pragma mark - Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate) {
        [textField resignFirstResponder];
        [self hide];
        [self.delegate didEndInputWithTextField:textField];
    }
    return YES;
}
@end
