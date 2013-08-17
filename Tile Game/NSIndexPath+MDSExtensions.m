//
//  NSIndexPath+MDSExtensions.m
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import "NSIndexPath+MDSExtensions.h"
#import <UIKit/UITableView.h>

@implementation NSIndexPath (MDSExtensions)

+ (NSIndexPath*) indexPathForRow:(NSInteger)row inColumn:(NSInteger)column {
  return [NSIndexPath indexPathForRow:row inSection:column];
}

- (NSInteger) column {
  return [self section];
}

@end
