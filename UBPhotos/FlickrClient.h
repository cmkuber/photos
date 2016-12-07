//
//  FlickrClient.h
//  UBPhotos
//
//  Created by Christian Kienle on 06/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrResponse;

typedef void(^FlickClientCompletionHandler)(FlickrResponse *response);

@interface FlickrClient : NSObject

- (instancetype)initWithAPIKey:(NSString *)APIKey;

- (void)requestPhotosFor:(NSString *)searchText
                    page:(NSUInteger)page
           photosPerPage:(NSUInteger)photosPerPage
       completionHandler:(FlickClientCompletionHandler)completionHandler;

@end

