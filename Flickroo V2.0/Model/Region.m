//
//  Region.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import "Region.h"

@implementation Region 

#define REGION_NAME_KEY @"name"
#define REGION_PHOTO_IDs @"photoIDs"
#define REGION_PHOTOGRAPHER_IDS @"photographerIDs"
#define REGION_UNIQUE_PHOTOGRAPHER_COUNT @"uniquePhotographerCount"

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.name forKey:REGION_NAME_KEY];
    [coder encodeObject:self.photographerIDs forKey:REGION_PHOTOGRAPHER_IDS];
    [coder encodeInt64:self.uniquePhotographerCount forKey:REGION_UNIQUE_PHOTOGRAPHER_COUNT];
    [coder encodeObject:self.photoIDs forKey:REGION_PHOTO_IDs];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    
    if (self) {
        self.name = [coder decodeObjectForKey:REGION_NAME_KEY];
        self.photographerIDs = [coder decodeObjectForKey:REGION_PHOTOGRAPHER_IDS];
        self.uniquePhotographerCount = [coder decodeInt64ForKey:REGION_UNIQUE_PHOTOGRAPHER_COUNT];
        self.photoIDs = [coder decodeObjectForKey:REGION_PHOTO_IDs];
    }
    
    return self;
}

@end
