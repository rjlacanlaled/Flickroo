//
//  Photographer.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import "Photographer.h"

@implementation Photographer
#define PHOTOGRAPHER_ID @"photogID"
#define PHOTOGRAPHER_NAME @"name"

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.photogID forKey:PHOTOGRAPHER_ID];
    [coder encodeObject:self.name forKey:PHOTOGRAPHER_NAME];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    
    if (self) {
        self.photogID = [coder decodeObjectForKey:PHOTOGRAPHER_ID];
        self.name = [coder decodeObjectForKey:PHOTOGRAPHER_NAME];
    }
    
    return self;
}
@end
