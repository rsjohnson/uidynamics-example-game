//
//  MDSTile.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSTile.h"

@implementation MDSTile

- (BOOL) isProperlyPositioned {
  return [self.properIndex compare:self.currentIndex] == NSOrderedSame;
}

- (void) setInitialIndex:(NSIndexPath *)initialIndex {
  _initialIndex = initialIndex;
  self.currentIndex = initialIndex;
}

@end
