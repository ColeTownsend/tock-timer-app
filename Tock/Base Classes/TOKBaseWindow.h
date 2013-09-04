//
//  TOKBaseWindow.h
//  Tock
//
//  Created by Rob DeRosa on 6/25/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface TOKBaseWindow : INAppStoreWindow

-(NSTextField*)getLabelWithString:(NSString*)string withFont:(NSFont*)font;

@end
