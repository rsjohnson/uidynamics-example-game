//
//  MDSTileSource.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/16/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSTileSource.h"

#import <CoreImage/CoreImage.h>
#import "MDSGameController.h"
#import "MDSTile.h"

@implementation MDSTileSource
{
  UIImage * _fullImage;
  NSMutableDictionary * _slicedImages;
  BOOL _isInUse;
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

  CGSize tileSize = (CGSize){_fullImage.size.width / _gridSize.width, _fullImage.size.height / _gridSize.height};
  
  for (int col = 0; col < _gridSize.width; col++) {
    for (int heightCounter =  0 ; heightCounter < _gridSize.height ; heightCounter++) {
        dispatch_async(tileQueue, ^{
          NSInteger row = _gridSize.height - heightCounter - 1; // normalize this to 0 based
          
          // create the tile frame and convert to CI coordinate space
          CGRect tileFrame = (CGRect){{col * tileSize.width, heightCounter * tileSize.height}, tileSize};
          tileFrame = CGRectApplyAffineTransform(tileFrame, CGAffineTransformMakeTranslation(1, -1));
          
          CGImageRef slicedImage = [ctx createCGImage:fullImage fromRect:tileFrame];
          NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inColumn:col];
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

- (NSArray*) randomizedTiles {
  NSMutableArray * tiles = [NSMutableArray array];
  NSMutableArray * allIndexes = [[_slicedImages allKeys] mutableCopy];
  
  NSInteger row = 0;
  NSInteger column = 0;
  NSInteger randomIndex = arc4random_uniform(allIndexes.count);
  while (allIndexes.count > 0) {
    NSIndexPath * indexPath = allIndexes[randomIndex];
    MDSTile * tile = [[MDSTile alloc] init];
    tile.image =_slicedImages[indexPath];
    tile.properIndex = indexPath;
    tile.initialIndex = [NSIndexPath indexPathForRow:row inColumn:column];
    [tiles addObject:tile];
    
    
    [allIndexes removeObjectAtIndex:randomIndex];
    column++;
    if (column >= self.gridSize.width) {
      column = 0;
      row++;
    }
    randomIndex = arc4random_uniform(allIndexes.count);
  }
  
  // remove one tile to create some blank space
  [tiles removeObjectAtIndex:arc4random_uniform(tiles.count)];
  
  return tiles;
}

#pragma mark - NSDisposableContent Protocol

- (BOOL) beginContentAccess {
  _isInUse = YES;
  return YES;
}

- (void) endContentAccess {
  _isInUse = NO;
}

- (void) discardContentIfPossible {
  if (_isInUse) {
    return;
  }
  
  _slicedImages = [NSMutableDictionary dictionary];
  _fullImage = nil;
}

- (BOOL) isContentDiscarded {
  return _slicedImages.count == 0;
}

@end
