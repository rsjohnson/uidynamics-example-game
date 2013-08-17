//
//  MDSGameController.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDSTileSource;
@class MDSGameController;

typedef void (^MDSGameReadyCallback)(MDSGameController* gameController);

/**
 * Manages all game logic
 */
@interface MDSGameController : NSObject

+ (MDSGameController*) sharedController;

/**
 * Creates a new game with a new tile source. Due to the async nature and performance of 
 * creating tiles that operates in a background thread, when the game is setup it will
 * execute the provided callback on the main thread
 * 
 * @param url the NSURL for the image to be divided into tiles
 * @param size the number of tiles to create
 * @param callback the block to execute upon creation of the tiles
 */
- (void) newGameWithImageAtURL:(NSURL*)url
                      gridSize:(CGSize)size
                 readyCallback:(MDSGameReadyCallback)callback;

@property (nonatomic, readonly, strong) NSArray * gameTiles;
@property (nonatomic, readonly, assign) CGSize gridSize;
@property (nonatomic, readonly, assign) NSIndexPath * openLocation;
@property (nonatomic, readonly, assign) BOOL isComplete;

@end
