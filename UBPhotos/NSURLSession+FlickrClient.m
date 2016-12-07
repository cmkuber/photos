//
//  NSURLSession+FlickrClient.m
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "NSURLSession+FlickrClient.h"


@implementation NSURLSession (FlickrClient)

+ (instancetype)newFlickClientSession {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = 1;
    configuration.timeoutIntervalForRequest = 30.0;
    configuration.timeoutIntervalForResource = 60.0 * 5.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

@end
