//
//  MDSTileView.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSTileView.h"
#import "MDSTile.h"

@implementation MDSTileView
{
  UIImageView * _imageView;
  UIDynamicAnimator * _animator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
      _imageView.contentMode = UIViewContentModeScaleToFill;
      [self addSubview:_imageView];
    }
    return self;
}

- (void) setTile:(MDSTile *)tile {
  _tile = tile;
  _imageView.image = tile.image;
}


@end
