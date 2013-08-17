//
//  MDSTileSource.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/16/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Container for the image data behind all tiles
 */
@interface MDSTileSource : NSObject
< NSDiscardableContent >

/**
 * The designated initializer. The actual splicing will block whatever queue its executed on, 
 * so you may want to instantiate objects on a background queue.
 *
 * @param url The url for the image data to load into the tile source
 * @param gridSize The size of the grid that the image should be sliced into
 */
- (MDSTileSource*) initWithImageURL:(NSURL*)url gridSize:(CGSize)gridSize;

/**
 * Provides an array of randomized MDSTiles, ordered by their initial position, one tile is removed 
 * to provide a space to move
 */
@property (nonatomic, readonly) NSArray * randomizedTiles;

@property (nonatomic, readonly, assign) CGSize gridSize;

@end
