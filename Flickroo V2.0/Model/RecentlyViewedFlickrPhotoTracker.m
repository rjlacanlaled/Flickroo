//
//  RecentlyViewedFlickrPhotoTracker.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/26/21.
//

#import "RecentlyViewedFlickrPhotoTracker.h"
#import "FlickrFetcher.h"

@implementation RecentlyViewedFlickrPhotoTracker

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (void)trackRecentlyViewedPhoto: (Photo *)photo {
    
    NSDate *currentDate = [NSDate date];
    NSMutableDictionary *photoWithDate = [[NSMutableDictionary alloc] init];
    NSString *photoID = photo.photoID;
    NSData *photoData = [NSKeyedArchiver archivedDataWithRootObject:photo];
    [photoWithDate setValue:currentDate forKey:@"dateViewed"];
    [photoWithDate setValue:photoID forKey:@"photoID"];
    [photoWithDate setValue:photoData forKey:@"photoViewed"];
        
    NSMutableArray *recentlyViewedFlickrPhotos = [[RecentlyViewedFlickrPhotoTracker getRecentlyViewedFlickrPhotos] mutableCopy];

    BOOL exists = NO;
    for (NSDictionary *dict in recentlyViewedFlickrPhotos) {
        if ([[dict valueForKeyPath:@"photoID"] isEqualToString:photoID]) {
            exists = YES;
            [recentlyViewedFlickrPhotos replaceObjectAtIndex:[recentlyViewedFlickrPhotos
                                                              indexOfObject:dict]
                                                withObject:photoWithDate];
            break;
        }
    }

    if (!exists) {
        [recentlyViewedFlickrPhotos addObject:photoWithDate];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:recentlyViewedFlickrPhotos forKey:@"recentlyViewedFlickrPhotos"];
}

+ (void)trackRecentlyCachedPhoto: (NSString *)imagePath {
    NSMutableArray *cachedPhotos = [[RecentlyViewedFlickrPhotoTracker getRecentlyCachedPhotos] mutableCopy];
    NSMutableDictionary *cachedPhotoDictionary = [[NSMutableDictionary alloc] init];
    [cachedPhotoDictionary setValue:imagePath forKey:@"imagePath"];
    
    BOOL exists = NO;
    for (NSDictionary *dict in cachedPhotos) {
        if ([[dict valueForKey:@"imagePath"] isEqualToString:imagePath]) {
            exists = YES;
        }
    }
    
    if (!exists) {
        [cachedPhotos addObject:cachedPhotoDictionary];
    }
    
    [RecentlyViewedFlickrPhotoTracker deleteOldCachedPhotos];
    
    [[NSUserDefaults standardUserDefaults] setValue:cachedPhotos forKey:@"recentlyCachedPhotos"];
    
}


+ (NSArray *)getRecentlyViewedFlickrPhotos {
    
    NSArray *photos = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentlyViewedFlickrPhotos"];
    
    if (photos) {
        return photos;
    } else {
        return [[NSArray alloc] init];
    }
}

+ (NSArray *)getRecentlyCachedPhotos {
    NSArray *cachedPhotos = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentlyCachedPhotos"];
    
    if (cachedPhotos) {
        return cachedPhotos;
    } else {
        return [[NSArray alloc] init];
    }
}

+ (NSArray *)recentlyViewedFlickrPhotosWithLimit: (NSInteger)limit {
    NSMutableArray *recentlyViewedFlickrPhotos = [[RecentlyViewedFlickrPhotoTracker getRecentlyViewedFlickrPhotos] mutableCopy];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateViewed" ascending:NO];

    [recentlyViewedFlickrPhotos sortUsingDescriptors:@[sortDescriptor]];
    NSMutableArray *recentlyViewedPhotosWithLimit = [[NSMutableArray alloc] init];
    
    int counter = 0;
    for (NSDictionary *photoWithDetails in recentlyViewedFlickrPhotos) {
        [recentlyViewedPhotosWithLimit addObject:photoWithDetails];
        counter++;
        if (counter >= limit) {
            break;
        }
    }
    
    return recentlyViewedPhotosWithLimit;
}

#define MAX_CACHED_PHOTOS 20

+ (void)deleteOldCachedPhotos {
    NSArray *recentPhotos = [RecentlyViewedFlickrPhotoTracker recentlyViewedFlickrPhotosWithLimit:MAX_CACHED_PHOTOS];
    NSArray *cachedPhotos = [RecentlyViewedFlickrPhotoTracker getRecentlyCachedPhotos];
    NSMutableArray *recentPhotosPath = [[NSMutableArray alloc] init];
    NSMutableArray *cachedPhotosPath = [[NSMutableArray alloc] init];
    for (NSDictionary *recentPhoto in recentPhotos) {
        NSData *photoData = [recentPhoto valueForKey:@"photoViewed"];
        Photo *photo = [NSKeyedUnarchiver unarchiveObjectWithData:photoData];
        NSString *path = [RecentlyViewedFlickrPhotoTracker createCachePathForPhotoURL:photo.imageURL];
        [recentPhotosPath addObject:path];
    }
    
    for (NSDictionary *cachedPhoto in cachedPhotos) {
        NSString *path = [cachedPhoto valueForKey:@"imagePath"];
        [cachedPhotosPath addObject:path];
    }
    
    NSMutableArray *pathsToDelete = [[NSMutableArray alloc] init];
    
    for (NSString *cachedPhotoPath in cachedPhotosPath) {
        if (![recentPhotosPath containsObject:cachedPhotosPath]) {
            [pathsToDelete addObject:cachedPhotoPath];
        }
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    for (NSString *path in pathsToDelete) {

        [manager removeItemAtPath:path error:nil];
    }
}

+ (NSString *)getCachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}


+ (NSString *)createCachePathForPhotoURL: (NSString *)stringURL {
    return [[self getCachesDirectory] stringByAppendingPathComponent:stringURL];
}

@end

