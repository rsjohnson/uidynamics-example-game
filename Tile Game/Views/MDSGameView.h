//
//  MDSGameView.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDSTileSource;

@interface MDSGameView : UIView

@property (nonatomic, strong, readonly) NSArray * tileViews;

- (void) addTiles;

- (CGPoint) centerForIndexPath:(NSIndexPath*)indexPath;

@end
