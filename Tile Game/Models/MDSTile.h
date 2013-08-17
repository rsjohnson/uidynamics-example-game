//
//  MDSTile.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSTile : NSObject

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSIndexPath * properIndex;
@property (nonatomic, strong) NSIndexPath * initialIndex;
@property (nonatomic, strong) NSIndexPath * currentIndex;
@property (nonatomic, assign, readonly) BOOL isProperlyPositioned;

@end
