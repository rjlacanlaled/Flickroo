//
//  Photo+FlickrFetch.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "Photo+FlickrFetch.h"
#import "Photo+Create.h"
#import "FlickrFetcher.h"
#import "FilePath.h"

#define SAVE_FILE_PATH @"photos_.plist"

@implementation Photo (FlickrFetch)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (Photo *)photoWithFlickrInfo: (NSDictionary *)photoDictionary {
    Photo *photo = nil;
    NSMutableArray *photosArray;
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    
    bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!exist) {
        // Create new record
        photosArray = [[NSMutableArray alloc] init];
    } else {
        // Fetch records in file
        
        photosArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        for (Photo *photoInArchiver in photosArray) {

            if ([photoInArchiver.photoID isEqualToString:[photoDictionary valueForKeyPath:FLICKR_PHOTO_ID]]) {
                return photoInArchiver;
            }
        }
    }
    
    // If record does not exist, create new record
    photo = [Photo createNewPhotoUsingPhotoDictionary:photoDictionary];
    [photosArray addObject:photo];
    
    // Save in file
    [NSKeyedArchiver archiveRootObject:photosArray toFile:path];
    return photo;
}

+ (void)photosWithFlickInfoArray: (NSArray *)photos {
    Photo *photo = nil;
    NSMutableArray *photosArray;
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    
    bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!exist) {
        // Create new record
        photosArray = [[NSMutableArray alloc] init];
        photo = [Photo createNewPhotoUsingPhotoDictionary:photos.firstObject];
        [photosArray addObject:photo];
        [NSKeyedArchiver archiveRootObject:photosArray toFile:path];
    }
    
    // Fetch records in file
    photosArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
    // Check for duplicates and save non-existing files
    for (NSDictionary *photoDictionary in photos) {
        Photo *newPhoto = [Photo createNewPhotoUsingPhotoDictionary:photoDictionary];

        BOOL exists = NO;
        for (Photo *photoInFile in photosArray) {
            if ([photoInFile.photoID isEqualToString:newPhoto.photoID]) {
                exists = YES;
                break;
            }
        }
        
        if (!exists) {
            [photosArray addObject:newPhoto];
        }
    }
    
    // Save in file
    [NSKeyedArchiver archiveRootObject:photosArray toFile:path];
}

+ (void)loadPhotos:(NSArray *)photos {
    [Photo photosWithFlickInfoArray:photos];
}

+ (NSArray *)fetchAllPhotos {
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
