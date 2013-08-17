//
//  NSIndexPath+MDSExtensions.h
//  Tile Game
//
//  Created by Ryan Johnson on 8/17/13.
//  Copyright (c) 2013 MDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (MDSExtensions)

+ (NSIndexPath*) indexPathForRow:(NSInteger)row inColumn:(NSInteger)column;

- (NSInteger) column;

@end
