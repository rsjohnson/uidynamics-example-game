//
//  MDSGameController.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSGameController.h"
#import "MDSTileSource.h"
#import "MDSTile.h"

@implementation MDSGameController
{
  NSCache * _tileCache;
  MDSTileSource * _tileSource;
}

+ (MDSGameController*) sharedController {
  static dispatch_once_t onceToken;
  static MDSGameController * sharedController;
  dispatch_once(&onceToken, ^{
    sharedController = [[self alloc] init];
  });
  return sharedController;
}

- (id)init
{
  self = [super init];
  if (self) {
    _tileCache = [[NSCache alloc] init];
  }
  return self;
}

- (void) newGameWithImageAtURL:(NSURL *)url
                   gridSize:(CGSize)size
                 readyCallback:(MDSGameReadyCallback)callback {
  dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
  dispatch_async(background, ^{
    [_tileSource endContentAccess];

    NSString * key = [NSString stringWithFormat:@"%@_%@", url, NSStringFromCGSize(size)];
    
    // hit the cache to see if we have this already
    _tileSource = [_tileCache objectForKey:key];
    if (!_tileSource || _tileSource.isContentDiscarded) {
       _tileSource = [[MDSTileSource alloc] initWithImageURL:url gridSize:size];
      [_tileCache setObject:_tileSource forKey:key];
    }
    
    [_tileSource beginContentAccess];
    
    _gameTiles = _tileSource.randomizedTiles;
    _gridSize = size;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      callback(self);
    });
  });
}

- (NSIndexPath*) openLocation {
  NSMutableArray * allPaths = [NSMutableArray array];
  
  for (int row = 0; row < self.gridSize.width; row++) {
    for (int col = 0 ; col < self.gridSize.height; col++) {
      [allPaths addObject:[NSIndexPath indexPathForRow:row inColumn:col]];
    }
  }
  
  NSMutableArray * currentPositions = [NSMutableArray array];
  for (MDSTile * tile in [MDSGameController sharedController].gameTiles) {
    [currentPositions addObject:tile.currentIndex];
  }
  
  [allPaths removeObjectsInArray:currentPositions];
  return [allPaths lastObject];
}

- (BOOL) isComplete {
  for (MDSTile * tile in self.gameTiles) {
    if ([tile.currentIndex compare:tile.properIndex] != NSOrderedSame) {
      return NO;
    }
  }
  
  return YES;
}

@end
