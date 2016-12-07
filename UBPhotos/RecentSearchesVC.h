//
//  RecentSearchesVC.h
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecentSearchesVC;

@protocol RecentSearchesVCDelegate
- (void)recentSearchesVC:(RecentSearchesVC *)recentSearchesController didSelectSearch:(NSString *)searchText;
@end

@interface RecentSearchesVC : UITableViewController
@property (weak) id<RecentSearchesVCDelegate> delegate;
@end


