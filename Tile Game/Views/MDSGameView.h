//
//  MDSGameView.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDSTileSource;
@class MDSTileView;

typedef enum {
  MDSShiftDirectionUp,
  MDSShiftDirectionDown,
  MDSShiftDirectionLeft,
  MDSShiftDirectionRight,
  MDSShiftDirectionNone
} MDSShiftDirection; /// Used to indicate what direction tiles need to shift when there is a tap event

@interface MDSGameView : UIView

@property (nonatomic, strong, readonly) NSArray * tileViews;

- (void) addTiles;

- (CGPoint) centerForIndexPath:(NSIndexPath*)indexPath;
- (NSArray*) tileViewsForShiftDirection:(MDSShiftDirection)direction relativeToTile:(MDSTileView*)tile;

@end
