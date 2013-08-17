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

@implementation MDSGameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) addTiles {
  CGSize gridSize = [MDSGameController sharedController].gridSize;
  NSArray * tiles = [MDSGameController sharedController].gameTiles;
  
  CGFloat tileViewWidth = CGRectGetWidth(self.frame) / gridSize.width;
  CGFloat tileViewHeight = CGRectGetHeight(self.frame) / gridSize.height;
  CGSize tileViewSize = (CGSize){ tileViewWidth, tileViewHeight };
    
  for (MDSTile * tile in tiles) {
    CGPoint tileOrigin = {tileViewWidth * tile.initialIndex.column, tileViewHeight * tile.initialIndex.row};
    UIImageView * temp = [[UIImageView alloc] initWithFrame:(CGRect){tileOrigin, tileViewSize}];
    temp.contentMode = UIViewContentModeScaleToFill;
    temp.image = tile.image;
    [self  addSubview:temp];                      
  }
}

@end
