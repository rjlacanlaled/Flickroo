//
//  RegionTVC.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import "RegionTVC.h"
#import "Region+Fetch.h"
#import "PhotoTVC.h"
#import "Photo+FlickrFetch.h"
#import "AppDelegate.h"
#import "RegionPhotoTVC.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "Photo+Delete.h"

@interface RegionTVC () <UISceneDelegate>
@property (strong, nonatomic) NSArray *regionData;
@end

@implementation RegionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    // Segue to PhotoTVC
    if ([segue.destinationViewController isKindOfClass:[RegionPhotoTVC class]]) {
        if ([segue.identifier isEqualToString:@"ShowPhotoList"]) {
            [self prepareRegionPhotoTVC:segue.destinationViewController withIndexPath: indexPath];
        }
    }
    
}

#pragma mark - Properties

@synthesize regionData = _regionData;

- (NSArray *)regionData {
    if (!_regionData) {
        _regionData = [[NSArray alloc] init];
    }
    return _regionData;
}

- (void)setRegionData:(NSArray *)regionData {
    _regionData = regionData;
    _regionData = [self sortRegionsByPhotographerCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#define MAX_ROWS 50

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.regionData count] > MAX_ROWS ? MAX_ROWS : [self.regionData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Region *region = self.regionData[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, region.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld photographer(s) | %ld photo(s)", region.uniquePhotographerCount, [region.photoIDs count]];
    return cell;
}

#pragma mark - Helper Methods

#define REGION_UNIQUE_PHOTOGRAPHER_COUNT @"uniquePhotographerCount"
#define REGION_NAME @"name"
- (NSArray *)sortRegionsByPhotographerCount {
    
    // Sort first by unique photographer count
    NSSortDescriptor *uniquePhotographerCount = [NSSortDescriptor
                                                 sortDescriptorWithKey:REGION_UNIQUE_PHOTOGRAPHER_COUNT
                                                 ascending:NO
                                                 selector:nil];
    // Then sort by regionName
    NSSortDescriptor *regionName = [NSSortDescriptor
                                          sortDescriptorWithKey:REGION_NAME
                                          ascending:YES
                                    selector:@selector(localizedCaseInsensitiveCompare:)];
    return [self.regionData sortedArrayUsingDescriptors:@[uniquePhotographerCount, regionName]];
}

- (void)fetchRegionData {
    self.regionData = [Region fetchAllRegion];
}

- (void)prepareRegionPhotoTVC: (RegionPhotoTVC *)photoTVC withIndexPath: (NSIndexPath *) indexPath {
    Region *region = self.regionData[indexPath.row];
    NSArray* photosInRegion = [self getPhotosInRegion: region];
    photoTVC.title = region.name;
    photoTVC.photos = photosInRegion;
}

- (NSArray *)getPhotosInRegion: (Region *)region {
    NSSet *photoIDsInRegion = region.photoIDs;
    NSMutableArray *photosInRegion = [[NSMutableArray alloc] init];
    NSArray *photos = [Photo fetchAllPhotos];
    
    for (Photo *photo in photos) {
        if ([photoIDsInRegion containsObject:photo.photoID]) {
            [photosInRegion addObject:photo];
        }
    }
    return photosInRegion;
}

- (void)setup {
    [self fetchRegionData];
    [self setupRefreshControl];
    [self fetchPhotos];
    [self setupNotifications];
    [self configureFetchTimer];
}

- (void)setupRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self action:@selector(fetchPhotos) forControlEvents:UIControlEventValueChanged];
}

- (void)fetchPhotos {
    if ([self isConnectedToWifi] || [self isConnectedToData]) {
        [self startRefreshControl];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchPhotos" object:nil];
    } else {
        NSLog(@"Cannot fetch because you are not connected to the internet...");
        [self stopRefreshControl];
    }
}

- (void)stopRefreshControl {
    NSLog(@"Done fetching or fetch has been aborted!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl endRefreshing];
    });
}

- (void)startRefreshControl {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl beginRefreshing];
    });
}

- (void)deletePhotos {
    NSLog(@"Deleting old photos..");
    [Photo deletePhotosWithDaysOld:0.0009];
    [self fetchRegionData];
}

#define FETCH_INTERVAL 60*30

- (void)configureFetchTimer {
    [NSTimer scheduledTimerWithTimeInterval:FETCH_INTERVAL
        target:self
        selector:@selector(fetchPhotosIfOnWifi)
        userInfo:nil
        repeats:YES];
}

- (void)configureDeleteTimer {
    [NSTimer scheduledTimerWithTimeInterval:45.0
        target:self
        selector:@selector(deletePhotos)
        userInfo:nil
        repeats:YES];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchRegionData)
                                                 name:@"RegionUpdate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopRefreshControl)
                                                 name:@"FlickrUpdate"
                                               object:nil];
}

- (void)fetchPhotosIfOnWifi {
    if ([self isConnectedToWifi]) {
        [self fetchPhotos];
    } else {
        NSLog(@"Fetch aborted because device is not connected to WiFi...");
    }
}

- (BOOL)isConnectedToWifi {
    Reachability *myNetwork = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    if (myStatus == ReachableViaWiFi) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isConnectedToData {
    Reachability *myNetwork = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    if (myStatus == ReachableViaWWAN) {
        return YES;
    }
    
    return NO;
}

@end
