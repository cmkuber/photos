//
//  FlickrResponse.h
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrResponse : NSObject

@property (readonly) NSUInteger page;
@property (readonly) NSUInteger pages;
@property (readonly) NSUInteger perPage;
@property (readonly) NSUInteger totalNumberOfPhotos;
@property (readonly) NSArray *photos;

+ (instancetype)newFromJSONDictionary:(NSDictionary *)dictionary;

@end
