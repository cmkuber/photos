//
//  PhotosVC.m
//  UBPhotos
//
//  Created by Christian Kienle on 06/12/2016.
//  Copyright © 2016 CMK. All rights reserved.
//

#import "PhotosVC.h"
#import "FlickrClient.h"
#import "FlickrCoordinator.h"
#import "PhotoCell.h"
#import "FlickrPhoto.h"
#import "RecentSearchesVC.h"
#import "NSUserDefaults+RecentSearches.h"

@interface PhotosVC () <FlickrCoordinatorDelegate, RecentSearchesVCDelegate, UISearchBarDelegate>

@property (strong) FlickrCoordinator *coordinator;

@end

@implementation PhotosVC

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.coordinator = [FlickrCoordinator new];
    self.coordinator.delegate = self;
    [self setupSearchBar_];
}

#pragma mark - UICollectionView Stuff
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.coordinator.numberOfPhotos;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"com.uber.photos.cell" forIndexPath:indexPath];
    NSUInteger page = [self pageForItem:indexPath.item];
    NSUInteger index = [self indexOfItem:indexPath.item];
    FlickrPhoto *photo = [self.coordinator photoAtIndex:index forPage:page];
    [cell configureWithPhoto:photo];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]], @"CollectionView has wrong layout.");
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat inset = flowLayout.sectionInset.left + flowLayout.sectionInset.right;
    CGFloat InteritemSpacing = flowLayout.minimumInteritemSpacing * (CGFloat)([self numberOfColmns] - 1); // -1 => 2 spaces for 3 columns
    CGFloat space = inset + InteritemSpacing;
    CGFloat width = (collectionView.bounds.size.width - space) / ((CGFloat)[self numberOfColmns]);
    CGFloat height = width;
    CGSize size = CGSizeMake(width, height);
    return size;
}

#pragma mark - Private Helper
- (NSUInteger)numberOfColmns {
    return 3;
}

- (NSUInteger)photosPerPageInResponse {
    return 30;
}

- (NSUInteger)rowsPerPage {
    return 10;
}

- (NSUInteger)rowForItem:(NSInteger)item {
    NSParameterAssert(item >= 0);
    NSUInteger row = item / [self numberOfColmns];
    return row;
}

- (NSUInteger)pageForItem:(NSInteger)item {
    NSParameterAssert(item >= 0);
    NSUInteger row = [self rowForItem:item];
    return (row / [self rowsPerPage]) + 1;
}

- (NSUInteger)indexOfItem:(NSInteger)item {
    NSParameterAssert(item >= 0);
    NSUInteger page = [self pageForItem:item]; // 1-based
    NSUInteger index = item - ((page - 1) * [self photosPerPageInResponse]);
    return index;
}

- (void)setupSearchBar_ {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width * 0.9, 30)];
    searchBar.placeholder = @"Search Flickr";
    searchBar.showsCancelButton = true;
    searchBar.showsBookmarkButton = true;
    searchBar.delegate = self;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = item;
}

- (UISearchBar *)searchBar_ {
    return self.navigationItem.rightBarButtonItem.customView;
}

#pragma mark - FlickrCoordinatorDelegate
- (void)flickrCoordinator:(FlickrCoordinator *)coordinator didLoadPhotosForPage:(NSUInteger)page {
    // TODO: Optimize
    [self.collectionView reloadData];
}

-(void)flickrCoordinator:(FlickrCoordinator *)coordinator didFailToLoadPhotosForPage:(NSUInteger)page {
    // TODO: Optimize
    [self.collectionView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[NSUserDefaults standardUserDefaults] addSearch:searchBar.text];
    [self.coordinator searchFor:searchBar.text photosPerPage:[self photosPerPageInResponse]];
    [searchBar endEditing:YES];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    RecentSearchesVC *recentSearchesVC = [RecentSearchesVC new];
    recentSearchesVC.delegate = self;
    [self.navigationController pushViewController:recentSearchesVC animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

#pragma mark RecentSearchesVCDelegate
- (void)recentSearchesVC:(RecentSearchesVC *)recentSearchesController didSelectSearch:(NSString *)searchText {
    [self.navigationController popToViewController:self animated:YES];
    [self.coordinator searchFor:searchText photosPerPage:[self photosPerPageInResponse]];
    [self searchBar_].text = searchText;
}

@end
