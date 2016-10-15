//
//  Storage.h
//  ConnectPlusPlus
//
//  Created by 杨思宇 on 10/15/16.
//  Copyright © 2016 hackbuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ResultBlock)(NSArray *messages);

@interface Storage : NSObject

+ (void)saveData:(NSString *)text withImage:(NSString *)image andLongtitude:(float) longtitude andLatitude:(float)latitude andTags:(NSString *)tags;

+ (void)saveImageMessage:(UIImage *)image withFilename:(NSString *) filename andLongtitude:(float) longtitude andLatitude:(float) latitude andTags:(NSArray *) tags;

+ (void)saveTextMessage:(NSString *)text withLongtitude:(float) longtitude andLatitude:(float) latitude andTags:(NSArray *) tags;

+ (NSString *)serializeTags:(NSArray *) tags;

+ (NSArray *)parseTags:(NSString *)serializedTags;

+ (void)getMessages:(ResultBlock)callback;

+ (void)getMessages:(NSDictionary *)lowerLeft withUpperRight:(NSDictionary *)upperRight andCallback:(ResultBlock)callback;

@end
