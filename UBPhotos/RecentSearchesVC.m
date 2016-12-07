//
//  RecentSearchesVC.m
//  UBPhotos
//
//  Created by Christian Kienle on 07/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "RecentSearchesVC.h"
#import "NSUserDefaults+RecentSearches.h"
@interface RecentSearchesVC ()

@end

@implementation RecentSearchesVC

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Recent Searches";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"com.uber.photos.recentSearchCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[NSUserDefaults standardUserDefaults] recentSearches] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.uber.photos.recentSearchCell" forIndexPath:indexPath];
    NSString *search = [[NSUserDefaults standardUserDefaults] recentSearches][indexPath.row];
    cell.textLabel.text = search;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *search = [[NSUserDefaults standardUserDefaults] recentSearches][indexPath.row];
    [self.delegate recentSearchesVC:self didSelectSearch:search];
    
}

@end
