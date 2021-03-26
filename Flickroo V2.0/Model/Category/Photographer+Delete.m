//
//  Photographer+Delete.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/27/21.
//

#import "Photographer+Delete.h"
#import "Photographer+Fetch.h"
#import "FilePath.h"

#define SAVE_FILE_PATH @"photographer_.plist"

@implementation Photographer (Delete)

#pragma GCC diagnostic ignored "-Wdeprecated"

+ (BOOL)deletePhotographer: (Photographer *)photographer {
    NSString *path = [FilePath filepathWithFilename:SAVE_FILE_PATH];
    NSMutableArray *photographerArray = [[Photographer fetchAllPhotographers] mutableCopy];
    
    for (Photographer *photographerInFile in photographerArray) {
        if ([photographerInFile.photogID isEqualToString:photographer.photogID]) {
            [photographerArray removeObject: photographerInFile];
            [NSKeyedArchiver archiveRootObject:photographerArray toFile:path];
            NSLog(@"photographer remaining: %ld", [[Photographer fetchAllPhotographers] count]);
            return YES;
        }
    }
    
    return NO;

}

@end
