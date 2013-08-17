//
//  MDSGameController.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSGameController.h"
#import "MDSTileSource.h"

@implementation MDSGameController

+ (MDSGameController*) sharedController {
  static dispatch_once_t onceToken;
  static MDSGameController * sharedController;
  dispatch_once(&onceToken, ^{
    sharedController = [[self alloc] init];
  });
  return sharedController;
}

- (void) newGameWithImageAtURL:(NSURL *)url
                   gridSize:(CGSize)size
                 readyCallback:(MDSGameReadyCallback)callback {
  dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
  dispatch_async(background, ^{
    _tileSource = [[MDSTileSource alloc] initWithImageURL:url gridSize:size];
    dispatch_async(dispatch_get_main_queue(), ^{
      callback(self);
    });
  });
}

@end
