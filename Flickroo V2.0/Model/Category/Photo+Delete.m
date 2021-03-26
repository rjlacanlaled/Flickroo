//
//  Photo+Delete.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/27/21.
//

#import "Photo+Delete.h"
#import "Photo+FlickrFetch.h"
#import "FilePath.h"
#import "Region.h"
#import "Region+Delete.h"
#import "Photographer+Delete.h"
#import "Region+Fetch.h"
#import "Photographer+Fetch.h"

#define SAVE_FILE_PATH_PHOTOS @"photos_.plist"
#define SAVE_FILE_PATH_REGIONS @"region_.plist"
#define SAVE_FILE_PATH_PHOTOGRAPHERS @"photographer_.plist"

@implementation Photo (Delete)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (BOOL)deletePhoto:(Photo *)photo {
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH_PHOTOS];
    NSMutableArray *photoArray = [[Photo fetchAllPhotos] mutableCopy];

    for (Photo *photoInFile in photoArray) {
        if ([photoInFile.photoID isEqualToString:photo.photoID]) {
            [photoArray removeObject: photoInFile];
            [NSKeyedArchiver archiveRootObject:photoArray toFile:path];
            NSLog(@"photos remaining: %ld", [[Photo fetchAllPhotos] count]);
            return YES;
        }
    }
    
    return NO;
}

+ (void)deletePhotosWithDaysOld: (float)daysOld {

}

+ (void)deleteOldPhotosWithDaysOld: (float)daysOld {

}
@end
