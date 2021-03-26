//
//  Region+Delete.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/27/21.
//

#import "Region+Delete.h"
#import "Region+Fetch.h"
#import "FilePath.h"

#define SAVE_FILE_PATH @"region_.plist"

@implementation Region (Delete)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (BOOL)deleteRegion: (Region *)region {
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    NSMutableArray *regionArray = [[Region fetchAllRegion] mutableCopy];
    
    for (Region *regionInFile in regionArray) {
        if ([regionInFile.name isEqualToString: region.name]) {
            [regionArray removeObject:regionInFile];
            [NSKeyedArchiver archiveRootObject:regionArray toFile:path];
            NSLog(@"region remaining: %ld", [[Region fetchAllRegion] count]);
            return YES;
        }
    }
    return NO;
}

@end
