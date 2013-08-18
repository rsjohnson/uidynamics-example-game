//
//  MDSGameView.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSGameView.h"
#import "MDSGameController.h"
#import "MDSTile.h"
#import "MDSTileView.h"

@implementation MDSGameView
{
  UIDynamicAnimator * _dynamicAnimator;
  NSMutableArray * _tileViews;
  CGSize _tileViewSize;
  CGSize _gridSize;
}

- (void) addTiles {
  _tileViews = [NSMutableArray array];
  
  _gridSize = [MDSGameController sharedController].gridSize;
  NSArray * tiles = [MDSGameController sharedController].gameTiles;
  
  CGFloat tileViewWidth = CGRectGetWidth(self.frame) / _gridSize.width;
  CGFloat tileViewHeight = CGRectGetHeight(self.frame) / _gridSize.height;
  _tileViewSize = (CGSize){ tileViewWidth, tileViewHeight };
    
  for (MDSTile * tile in tiles) {
    CGPoint tileOrigin = {tileViewWidth * tile.initialIndex.column, tileViewHeight * tile.initialIndex.row};
    MDSTileView * tileView = [[MDSTileView alloc] initWithFrame:(CGRect){tileOrigin, _tileViewSize}];
    tileView.tile = tile;
    [self  addSubview:tileView];
    [_tileViews addObject:tileView];
  }
}

- (NSArray*) tileViews {
  return _tileViews;
}

- (CGPoint) centerForIndexPath:(NSIndexPath*)indexPath {
  CGPoint tileOrigin = {_tileViewSize.width * indexPath.column, _tileViewSize.height * indexPath.row};
  CGRect tileFrame = (CGRect){tileOrigin, _tileViewSize};
  return (CGPoint){CGRectGetMidX(tileFrame), CGRectGetMidY(tileFrame)};
}

- (NSArray*) tileViewsForShiftDirection:(MDSShiftDirection)direction
                         relativeToTile:(MDSTileView *)tile {
  NSMutableArray * tiles = [NSMutableArray array];
  NSIndexPath * openPosition = [MDSGameController sharedController].openLocation;
  
  for (MDSTileView * tileView in self.tileViews) {
    switch (direction) {
      case MDSShiftDirectionRight:
        if (tileView.tile.currentIndex.row == tile.tile.currentIndex.row &&
            tileView.tile.currentIndex.column > tile.tile.currentIndex.column &&
            tileView.tile.currentIndex.column < openPosition.column) {
          [tiles addObject:tileView];
        }
        break;
      case MDSShiftDirectionLeft:
        if (tileView.tile.currentIndex.row == tile.tile.currentIndex.row &&
            tileView.tile.currentIndex.column < tile.tile.currentIndex.column &&
            tileView.tile.currentIndex.column > openPosition.column) {
          [tiles addObject:tileView];
        }
        break;
      case MDSShiftDirectionUp:
        if (tileView.tile.currentIndex.row < tile.tile.currentIndex.row &&
            tileView.tile.currentIndex.column == tile.tile.currentIndex.column &&
            tileView.tile.currentIndex.row > openPosition.row) {
          [tiles addObject:tileView];
        }
        break;
      case MDSShiftDirectionDown:
        if (tileView.tile.currentIndex.row > tile.tile.currentIndex.row &&
            tileView.tile.currentIndex.column == tile.tile.currentIndex.column &&
            tileView.tile.currentIndex.row < openPosition.row) {
          [tiles addObject:tileView];
        }
        break;
      case MDSShiftDirectionNone:
        break;
    }
  }
  
  return tiles;
}

@end
