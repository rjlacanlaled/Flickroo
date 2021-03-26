//
//  Photographer+Fetch.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/27/21.
//

#import "Photographer+Fetch.h"
#import "FilePath.h"

#define SAVE_FILE_PATH @"photographer_.plist"

@implementation Photographer (Fetch)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (NSArray *)fetchAllPhotographers {
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
