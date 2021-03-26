//
//  Thumbnail+Fetch.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import "Thumbnail+Fetch.h"
#import "FilePath.h"

#define SAVE_FILE_PATH @"thumbnails_.plist"

@implementation Thumbnail (Fetch)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (Thumbnail *)fetchThumbnailWithPhotoID: (NSString *)photoID {
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    NSArray *thumbnails = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    for (Thumbnail *thumbnail in thumbnails) {
        if ([thumbnail.photoID isEqualToString:photoID]) {
            return thumbnail;
        }
    }
    
    return nil;
}

+ (Thumbnail *)createNewThumbnailForPhotoID: (NSString *)photoID withData: (NSData *)thumbnailData {
    
    Thumbnail *thumbnail;
    NSMutableArray *thumbnailArray;
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];

    bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!exist) {
        // Create an initial array holder
        thumbnailArray = [[NSMutableArray alloc] init];
        
        // Create the first record to be saved
        thumbnail = [Thumbnail addNewThumbnailForPhotoID:photoID withData:thumbnailData];
        [thumbnailArray addObject:thumbnail];
        
        // Save in file
      [NSKeyedArchiver archiveRootObject:thumbnailArray toFile:path];
    } else {
     thumbnailArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        bool exists = NO;
        for (Thumbnail *thumbnail in thumbnailArray) {
            if ([thumbnail.photoID isEqualToString:photoID]) {
                exists = YES;
                break;
            }
        }
        
        if (!exists) {
            thumbnail = [Thumbnail addNewThumbnailForPhotoID:photoID withData:thumbnailData];
            [thumbnailArray addObject:thumbnail];
            [NSKeyedArchiver archiveRootObject:thumbnailArray toFile:path];
        }
    }
    
    return thumbnail;
}

+ (Thumbnail *)addNewThumbnailForPhotoID: (NSString *)photoID withData: (NSData *)data {
    Thumbnail *thumbnail = [[Thumbnail alloc] init];
    thumbnail.photoID = photoID;
    thumbnail.thumbnail = data;
    return thumbnail;
}


@end
