//
//  MDSStartScreenViewController.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "MDSStartScreenViewController.h"
#import "MDSGameController.h"
#import "MDSInGameViewController.h"

@interface MDSStartScreenViewController ()

@end

@implementation MDSStartScreenViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSInteger imageTag = [sender tag];
  MDSInGameViewController * inGameVC = segue.destinationViewController;
  
  if (imageTag == MDSStartScreenImageGlobe) {
    NSURL * globeURL = [[NSBundle mainBundle] URLForResource:@"globe" withExtension:@"jpg"];
    [[MDSGameController sharedController] newGameWithImageAtURL:globeURL
                                                       gridSize:(CGSize){4,4}
                                                  readyCallback:^(MDSGameController *gameController) {
                                                    [inGameVC gameDidLoad];
                                                  }];
  }
}

@end
