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
#import "MDSTileView.h"
#import "MDSTile.h"

@interface MDSInGameViewController ()

@property UIDynamicAnimator * animator;

@end

@implementation MDSInGameViewController
{
  BOOL _gameIsReady;
  UISnapBehavior *_snapBehavior;
  NSIndexPath * _openPosition;
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
  
  [self updateOpenPosition];
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
  [self addGestureRecognizers];
}

- (void) addGestureRecognizers {
  for (MDSTileView * tileView in self.gameView.tileViews) {
    UIPanGestureRecognizer * panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(didPan:)];
    
    // make sure the swipe doesn't get caught by iOS 7's new swipe to pop GR on nav controllers
    [self.navigationController.interactivePopGestureRecognizer requireGestureRecognizerToFail:panGR];
    
    [tileView addGestureRecognizer:panGR];
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [tileView addGestureRecognizer:tapGR];
  }
}

#pragma mark - 

- (void) updateOpenPosition {
  _openPosition = [MDSGameController sharedController].openLocation;
  if ([MDSGameController sharedController].isComplete) {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You Win!"
                                                     message:nil
                                                    delegate:nil
                                           cancelButtonTitle:@"Sweet!"
                                           otherButtonTitles:nil];
    [alert show];
  }
}

#pragma mark - Gesture Recognizer Callbacks

- (void) didTap:(UITapGestureRecognizer*) tapGR {
  NSLog(@"%@", tapGR.view);
}

- (void) didPan:(UIPanGestureRecognizer*)panGR {
  static CGPoint lastTranslation;
  MDSTileView * tileView = (MDSTileView*)panGR.view;
  
  // if we don't remove any other snap behavior we don't get the sexy bouncing effect consistently
  // nor will we be able to move a view twice in a row
  [self.animator removeBehavior:_snapBehavior];
  
  if (panGR.state == UIGestureRecognizerStateBegan) {
    lastTranslation = (CGPoint)[panGR translationInView:panGR.view.superview];
  }
  else if (panGR.state == UIGestureRecognizerStateChanged ) {
    [self.gameView bringSubviewToFront:panGR.view];
    CGPoint currentTranslation = [panGR translationInView:panGR.view.superview];
    CGPoint panTranslation = (CGPoint){currentTranslation.x - lastTranslation.x, currentTranslation.y - lastTranslation.y};
    lastTranslation = currentTranslation;
    tileView.frame = CGRectOffset(tileView.frame, panTranslation.x, panTranslation.y);
  }
  else if (panGR.state == UIGestureRecognizerStateEnded) {
    CGPoint openPositionCenter = [self.gameView centerForIndexPath:_openPosition];
    CGPoint originalCenter = [self.gameView centerForIndexPath:tileView.tile.currentIndex];
    CGPoint currentTranslation = [panGR translationInView:panGR.view.superview];
    CGPoint currentCenter = {currentTranslation.x + originalCenter.x, currentTranslation.y + originalCenter.y};
    CGFloat distanceFromStart = abs(currentCenter.x - originalCenter.x) + abs(currentCenter.y - originalCenter.y);
    CGFloat distanceFromOpen = abs(currentCenter.x - openPositionCenter.x) + abs(currentCenter.y - openPositionCenter.y);
    CGPoint snapPoint = originalCenter;

    if (distanceFromOpen < distanceFromStart) {
      tileView.tile.currentIndex = _openPosition;
      [self updateOpenPosition];
      snapPoint = openPositionCenter;
    }

    _snapBehavior = [[UISnapBehavior alloc] initWithItem:tileView
                                             snapToPoint:snapPoint];
    [self.animator addBehavior:_snapBehavior];
    
  }
}



@end
