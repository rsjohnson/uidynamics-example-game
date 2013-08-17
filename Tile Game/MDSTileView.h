//
//  MDSTileView.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDSTile;

@interface MDSTileView : UIView

@property (nonatomic, strong) MDSTile * tile;
@property (nonatomic, strong, readonly) UIPushBehavior * pushBehavior;

@end
