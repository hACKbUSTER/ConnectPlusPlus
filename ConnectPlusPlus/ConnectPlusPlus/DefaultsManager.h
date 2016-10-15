//
//  DefaultsManager.h
//  ConnectPlusPlus
//
//  Created by 叔 陈 on 2016/10/16.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJLocationManager.h"

@interface DefaultsManager : NSObject

@property (nonatomic) CLLocationCoordinate2D currentLocation;

+ (DefaultsManager *)sharedManager;

- (void)addTag:(NSString *)tag;
- (NSArray *)getTags;
- (BOOL)deleteTag:(NSString *)tag;

@end
