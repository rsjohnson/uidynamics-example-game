//
//  MDSInGameViewController.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDSGameView;

@interface MDSInGameViewController : UIViewController

@property (nonatomic, weak) IBOutlet MDSGameView * gameView;

- (void) gameDidLoad;

@end
