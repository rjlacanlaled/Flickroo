//
//  FilePath.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import "FilePath.h"

@implementation FilePath


+ (NSString *)filepathWithFilename:(NSString*)filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                      objectAtIndex:0];
    path = [path stringByAppendingPathComponent:filename];
    return path;
}

@end
