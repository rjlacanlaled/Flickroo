//
//  ImageVC.m
//  Flickroo V2.0
//
//  Created by RJ Lacanlale on 1/24/21.
//

#import "ImageVC.h"
#import "RecentlyViewedFlickrPhotoTracker.h"

@interface ImageVC () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageDownloadActivityIndicator;

@end

@implementation ImageVC

#pragma GCC diagnostic ignored "-Wdeprecated"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageScrollView addSubview:self.imageView];
}



#pragma mark - Properties

@synthesize imageURL = _imageURL;

- (NSURL *)imageURL {
    if (!_imageURL) {
        _imageURL = [[NSURL alloc] init];
    }
    return _imageURL;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    NSString *pathOfImage = [self createCachePathForPhotoURL:[imageURL absoluteString]];

    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:pathOfImage];
    
    if (exists) {
        NSLog(@"exists");
        [self getImageAtPath: pathOfImage];
    } else {
        [self downloadImage];
    }
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImageScrollView: imageScrollView {
    _imageScrollView = imageScrollView;
    _imageScrollView.minimumZoomScale = 0.2;
    _imageScrollView.maximumZoomScale = 2.0;
    _imageScrollView.delegate = self;
    _imageScrollView.contentSize = [self sizeOfImage];
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.imageScrollView.contentSize = [self sizeOfImage];
    [self.imageDownloadActivityIndicator stopAnimating];
}

#pragma mark - ScrollView Delegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Helper Methods

- (CGSize)sizeOfImage {
    if (self.image) {
            return self.image.size;
    }
    return CGSizeZero;
}

- (void)downloadImage {
    self.image = nil;
    if (self.imageURL) {
        [self.imageDownloadActivityIndicator startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL * _Nullable localFile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (!error) {
                if ([request.URL isEqual:self.imageURL]) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *cachePathForImage = [self createCachePathForPhotoURL:[request.URL absoluteString]];
                        NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:[NSData dataWithContentsOfURL:localFile]];
                        [imageData writeToFile:cachePathForImage atomically:YES];
                        [RecentlyViewedFlickrPhotoTracker trackRecentlyCachedPhoto:cachePathForImage];
                        self.image = image;
                    });
                }
            }
            
        }];
        
        [task resume];
    }
}

- (NSString *)getCachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}


- (NSString *)createCachePathForPhotoURL: (NSString *)stringURL {
    return [[self getCachesDirectory] stringByAppendingPathComponent:stringURL];
}

- (void)getImageAtPath: (NSString *)path {
    NSData *imageData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.image = [UIImage imageWithData:imageData];
}

@end
