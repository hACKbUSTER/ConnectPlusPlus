//
//  NetworkManager.m
//  ConnectPlusPlus
//
//  Created by Cee on 15/10/2016.
//  Copyright © 2016 hackbuster. All rights reserved.
//

#import <AFNetworking.h>
#import "NetworkManager.h"

@implementation NetworkManager

+ (id)sharedManager {
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)getJSONWithImageData:(NSData *)data
                     success:(successWithObjectBlock)onSuccess
                     failure:(failErrorBlock)onFailure {
    NSDictionary *URLParameters = @{
                                    @"visualFeatures":@"Categories,Tags,Description",
                                    @"details":@"Celebrities",
                                    };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:kOcpApimBaseURL
                                                                                parameters:URLParameters error:nil];
    
    [request setValue:kOcpApimSubscriptionKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    if (error) {
                        onFailure(error);
                    } else {
                        onSuccess(responseObject);
                    }
                }] resume];
}

- (void)getImageFromBingWithString:(NSString *)string
                           success:(successWithObjectBlock)onSuccess
                           failure:(failErrorBlock)onFailure
{
    NSDictionary *URLParameters = @{
                                    @"q":string,
                                    @"mkt":@"en-us",
                                    @"safeSearch":@"strict",
                                    @"imageType":@"photo",
                                    @"size":@"Wallpaper"
                                    };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                 URLString:kBingImageSearchURL
                                                                                parameters:URLParameters error:nil];
    
    [request setValue:kBingImageSearchKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    if (error) {
                        onFailure(error);
                    } else {
                        NSArray *valueArray = [responseObject objectForKey:@"value"];
                        onSuccess([[valueArray objectAtIndex:0] objectForKey:@"contentUrl"]);
                    }
                }] resume];

}

@end
