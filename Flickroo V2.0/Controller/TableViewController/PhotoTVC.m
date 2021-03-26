//
//  PhotoTVC.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import "PhotoTVC.h"
#import "Photo.h"
#import "ImageVC.h"
#import "FlickrFetcher.h"
#import "Thumbnail+Fetch.h"
#import "RecentlyViewedFlickrPhotoTracker.h"
#import "RegionPhotoTVC.h"
#import "RecentlyViewedPhotoTVC.h"

@interface PhotoTVC () <NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *thumbnailURLstoDownload;
@end

@implementation PhotoTVC 

#pragma GCC diagnostic ignored "-Wdeprecated"

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.destinationViewController isKindOfClass:[ImageVC class]]) {
        if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
            [self prepareImageVC: segue.destinationViewController withIndexPath: indexPath];
        }
    }
}


- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {

    [Thumbnail createNewThumbnailForPhotoID:downloadTask.taskDescription withData:[NSData dataWithContentsOfURL:location]];
 
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Properties

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}

- (NSMutableArray *)thumbnailURLstoDownload {
    if (!_thumbnailURLstoDownload) {
        _thumbnailURLstoDownload = [[NSMutableArray alloc] init];
    }
    return _thumbnailURLstoDownload;    
}


@synthesize photos = _photos;

- (NSArray *)photos {
    if (!_photos) {
        _photos = [[NSArray alloc] init];
    }
    return _photos;
}

- (void)setPhotos:(NSArray *)photos {
    _photos = [self sortPhotos: photos];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Photo *photo = self.photos[indexPath.row];
        
    // Set title and subtitle
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@ by %@\n\n", indexPath.row + 1, photo.title, photo.photographer.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n\n", photo.subtitle];
    
    // Get thumbnail and download if necessary
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imageView.layer.borderWidth = 0.75f;
        cell.imageView.layer.borderColor = [UIColor redColor].CGColor;
        cell.imageView.image = [self getThumbnailForPhoto:photo];
        [cell setNeedsLayout];
    });
        
    return cell;
}


#pragma mark - Helper Methods

#define PHOTO_OWNER_NAME @"photographer.name"
#define PHOTO_TITLE @"title"

- (NSArray *)sortPhotosByTitle: (NSArray *)photos {
    NSSortDescriptor *photoTitle = [NSSortDescriptor
                                          sortDescriptorWithKey:PHOTO_TITLE
                                          ascending:YES
                                          selector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [photos sortedArrayUsingDescriptors:@[photoTitle]];
}

- (NSArray *)sortRecentlyViewedPhotosByViewedDate: (NSArray *)photos {
    NSSortDescriptor *viewedDate = [NSSortDescriptor
                                    sortDescriptorWithKey:DATE_VIEWED
                                    ascending:NO];
    NSArray *tempArray = [photos sortedArrayUsingDescriptors:@[viewedDate]];
    NSMutableArray *photosArray = [[NSMutableArray alloc] init];
    for (NSDictionary *photoDictionary in tempArray) {
        Photo *photo = [NSKeyedUnarchiver unarchiveObjectWithData:[photoDictionary valueForKeyPath:PHOTO_VIEWED]];
        [photosArray addObject:photo];
    }
    return photosArray;
}

- (void)prepareImageVC: (ImageVC *)imageVC withIndexPath: (NSIndexPath *)indexPath {
    Photo *photo = self.photos[indexPath.row];
    imageVC.title = photo.title;
    imageVC.imageURL = [NSURL URLWithString:photo.imageURL];
    [RecentlyViewedFlickrPhotoTracker trackRecentlyViewedPhoto:photo];
}

- (UIImage *)getThumbnailForPhoto: (Photo *)photo {
    Thumbnail *thumbnail = [Thumbnail fetchThumbnailWithPhotoID:photo.photoID];
    
    if (thumbnail) {
        return [UIImage imageWithData:thumbnail.thumbnail];
    } else {
        [self downloadThumbnailDataWithURL:[NSURL URLWithString:photo.thumbnailURL] withPhotoID:photo.photoID];
    }
    
    return [UIImage imageNamed:@"thumbnail_placeholder"];;
}

- (void)downloadThumbnailDataWithURL: (NSURL *)url withPhotoID: (NSString *)photoID {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    task.taskDescription = photoID;
    [task resume];
}

- (NSArray *)sortPhotos: (NSArray *)photos {
    if ([self isKindOfClass:[RegionPhotoTVC class]]) {
        return [self sortPhotosByTitle: photos];
    } else {
        return [self sortRecentlyViewedPhotosByViewedDate: photos];
    }
}

#define RECENTLY_VIEWED_LIMIT 20
- (void)updateRecentlyViewedPhotos {
    
    self.photos = [RecentlyViewedFlickrPhotoTracker recentlyViewedFlickrPhotosWithLimit:RECENTLY_VIEWED_LIMIT];
}

@end
