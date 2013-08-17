//
//  MDSInGameViewController.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSInGameViewController.h"
#import "MDSGameController.h"
#import "MDSGameView.h"

@interface MDSInGameViewController ()

@end

@implementation MDSInGameViewController
{
  BOOL _gameIsReady;
}

- (void) viewDidLoad {
  [super viewDidLoad];
  
  if (_gameIsReady) {
    [self configureForGame];
  }
}


#pragma mark - View Setup
- (void) gameDidLoad {
  _gameIsReady = YES;
  
  if (self.gameView) {
    [self configureForGame];
  }
}

- (void) configureForGame {
  [self.gameView addTiles];
}

@end
