//
//  Region.h
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/22/21.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject <NSCoding>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSSet *photoIDs;
@property (strong, nonatomic) NSSet *photographerIDs;
@property (nonatomic)  NSInteger uniquePhotographerCount;
@end


