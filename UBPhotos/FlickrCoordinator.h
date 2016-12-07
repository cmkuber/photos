//
//  FlickrCoordinator.h
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrCoordinator;

@protocol FlickrCoordinatorDelegate
- (void)flickrCoordinator:(nonnull FlickrCoordinator *)coordinator didLoadPhotosForPage:(NSUInteger)page;
- (void)flickrCoordinator:(nonnull FlickrCoordinator *)coordinator didFailToLoadPhotosForPage:(NSUInteger)page;
@end

@class FlickrPhoto;
@interface FlickrCoordinator : NSObject

@property (nullable, weak) id<FlickrCoordinatorDelegate> delegate;
@property (readonly) NSUInteger numberOfPhotos;

- (nullable FlickrPhoto *)photoAtIndex:(NSUInteger)index forPage:(NSUInteger)page;
- (void)searchFor:(nonnull NSString *)searchText photosPerPage:(NSUInteger)photosPerPage;

@end

