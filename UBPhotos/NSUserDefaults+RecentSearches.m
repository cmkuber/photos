//
//  RecentSearchesCoordinator.m
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "NSUserDefaults+RecentSearches.h"

NSString *const PhototsUserDefaultsRecentSearchesKey = @"com.uber.photos.ud.recentSearches";

@implementation NSUserDefaults (IB)

- (NSArray *)recentSearches {
    NSArray *result = [self arrayForKey:PhototsUserDefaultsRecentSearchesKey];
    if(result == nil) {
        result = @[];
        [self setObject:@[] forKey:PhototsUserDefaultsRecentSearchesKey];
    }
    return result;
}

- (void)addSearch:(NSString *)text {
    if(text == nil || text.length == 0) {
        return;
    }
    NSMutableArray *searches = [self.recentSearches mutableCopy];
    [searches removeObject:text];
    [searches insertObject:text atIndex:0];
    [self setObject:searches forKey:PhototsUserDefaultsRecentSearchesKey];
}

@end
