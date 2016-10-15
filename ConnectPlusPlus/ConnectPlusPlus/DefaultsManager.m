//
//  DefaultsManager.m
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "DefaultsManager.h"

@interface DefaultsManager()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation DefaultsManager

+ (DefaultsManager *)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)addTag:(NSString *)tag
{
    if ([self.userDefaults objectForKey:@"taglist"]) {
        NSMutableArray *t = [[self.userDefaults objectForKey:@"taglist"] mutableCopy];
        if (![t containsObject:tag]) {
            [t addObject:tag];
        }
        [self.userDefaults setValue:t forKey:@"taglist"];
    } else {
        // if not existed, then initialize it
        NSMutableArray *t = [NSMutableArray array];
        [self.userDefaults setValue:t forKey:@"taglist"];
    }
}

- (NSArray *)getTags
{
    if ([self.userDefaults objectForKey:@"taglist"]) {
        return [self.userDefaults objectForKey:@"taglist"];
    } else {
        return @[];
    }
}

- (BOOL)deleteTag:(NSString *)tag
{
    if ([self.userDefaults objectForKey:@"taglist"]) {
        NSMutableArray *t = [[self.userDefaults objectForKey:@"taglist"] mutableCopy];
        for (int i = 0; i < t.count; i++) {
            if ([t[i] isEqualToString:tag]) {
                [t removeObjectAtIndex:i];
                [self.userDefaults setValue:t forKey:@"taglist"];
                return YES;
            }
        }
        return NO;
    } else {
        return NO;
    }
}

@end
