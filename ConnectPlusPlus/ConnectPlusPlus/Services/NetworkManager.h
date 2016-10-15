//
//  NetworkManager.h
//  ConnectPlusPlus
//
//  Created by Cee on 15/10/2016.
//  Copyright © 2016 hackbuster. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOcpApimBaseURL                     @"https://api.projectoxford.ai/vision/v1.0/analyze"
#define kOcpApimSubscriptionKey             @"572ebd0136424bca8a4b392ec6221b5e"

typedef void (^successWithObjectBlock)(id object);
typedef void (^failErrorBlock)(NSError *error);

@interface NetworkManager : NSObject

+ (id)sharedManager;
- (void)getJSONWithImageData:(NSData *)data
                     success:(successWithObjectBlock)onSuccess
                     failure:(failErrorBlock)onFailure;

@end
