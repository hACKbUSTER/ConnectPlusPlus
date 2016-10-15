//
//  DefaultsManager.h
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsManager : NSObject

+ (DefaultsManager *)sharedManager;

- (void)addTag:(NSString *)tag;
- (NSArray *)getTags;
- (BOOL)deleteTag:(NSString *)tag;

@end
