//
//  Thumbnail.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import "Thumbnail.h"

//@property (strong, nonatomic) Photo *photo;
//@property (strong, nonatomic) NSData *thumbnail;

#define PHOTO_KEY @"photo"
#define THUMBNAIL_KEY @"thumbnail"

@implementation Thumbnail

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.photoID forKey:PHOTO_KEY];
    [coder encodeObject:self.thumbnail forKey:THUMBNAIL_KEY];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    
    if (self) {
        self.photoID = [coder decodeObjectForKey:PHOTO_KEY];
        self.thumbnail = [coder decodeObjectForKey:THUMBNAIL_KEY];
    }
    
    return self;
}

@end
