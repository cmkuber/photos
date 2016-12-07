//
//  RecentSearchesCoordinator.h
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults (UB)

@property (readonly) NSArray *recentSearches;
- (void)addSearch:(NSString *)text;

@end
