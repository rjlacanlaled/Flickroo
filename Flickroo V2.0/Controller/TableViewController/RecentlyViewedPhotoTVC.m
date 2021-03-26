//
//  RecentlyViewedPhotoTVC.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/26/21.
//

#import "RecentlyViewedPhotoTVC.h"

@interface RecentlyViewedPhotoTVC ()

@end

@implementation RecentlyViewedPhotoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateRecentlyViewedPhotos];
}

@end
