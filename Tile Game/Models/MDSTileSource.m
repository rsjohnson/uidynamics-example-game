//
//  MDSTileSource.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/16/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSTileSource.h"
#import <CoreImage/CoreImage.h>

@implementation MDSTileSource
{
  CGSize _gridSize;
  UIImage * _fullImage;
  NSMutableDictionary * _slicedImages;
}

- (MDSTileSource*) initWithImageURL:(NSURL *)url gridSize:(CGSize)gridSize {
  NSAssert(gridSize.width > 0 && gridSize.height > 0, @"Tile Sources Must Have A Valid Grid Size");
  
  self = [super init];
  if (self) {
    _gridSize = gridSize;
    
    _fullImage = [UIImage imageWithContentsOfFile:url.path];
    NSAssert(_fullImage, @"Tile Sources Must Be Initialized With Valid Image Data");
    
    _slicedImages = [NSMutableDictionary dictionary];
    [self createTiles];
  }
  

  return self;
}

- (void) createTiles {
  // incase you're wondering I'm using GCD here instead of NSOperationQueue as GCD will scale
  // to the available resources / cores on the device.
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  dispatch_queue_t tileQueue = dispatch_queue_create("net.mds.tilesplicer", DISPATCH_QUEUE_CONCURRENT);
  
  NSDate * sliceTimer = [NSDate date];
  
  CIContext * ctx = [CIContext contextWithOptions:nil];
  CIImage * fullImage = [CIImage imageWithCGImage:_fullImage.CGImage];
  CGRect imageFrame = (CGRect){{0,0}, _fullImage.size};
  NSLog(@"%@", NSStringFromCGRect(imageFrame));
  CGSize tileSize = (CGSize){_fullImage.size.width / _gridSize.width, _fullImage.size.height / _gridSize.height};
  
  for (int row = 0; row < _gridSize.width; row++) {
    for (int heightCounter =  0 ; heightCounter < _gridSize.height ; heightCounter++) {
        dispatch_async(tileQueue, ^{
          NSInteger column = _gridSize.height - heightCounter - 1; // normalize this to 0 based
          
          CGRect tileFrame = (CGRect){{row * tileSize.width, heightCounter * tileSize.height}, tileSize};
          tileFrame = CGRectApplyAffineTransform(tileFrame, CGAffineTransformMakeTranslation(1, -1));
          
          CGImageRef slicedImage = [ctx createCGImage:fullImage fromRect:tileFrame];
          NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inColumn:column];
          UIImage * finalSlicedImage = [UIImage imageWithCGImage:slicedImage];
          _slicedImages[indexPath] = finalSlicedImage;
#if TARGET_IPHONE_SIMULATOR
          NSData * pngData = UIImagePNGRepresentation(finalSlicedImage);
          NSString * path = [NSString stringWithFormat:@"/tmp/%i_%i.png", row, column];
          [pngData writeToFile:path atomically:YES];
#endif
        });
    }
  }
  
  // tell any waiting queues that we're done processing
  dispatch_barrier_async(tileQueue, ^{
    dispatch_semaphore_signal(semaphore);
  });
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  NSLog(@"Slicing Complete. Elapsed Time: %f", -[sliceTimer timeIntervalSinceNow]);
}



@end
