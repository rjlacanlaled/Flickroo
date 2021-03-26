//
//  Photo.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import <Foundation/Foundation.h>
#import "Photographer.h"

@interface Photo : NSObject <NSCoding>
@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *thumbnailURL;
@property (strong, nonatomic) NSDate *uploadDate;
@property (strong, nonatomic) Photographer *photographer;
@end
