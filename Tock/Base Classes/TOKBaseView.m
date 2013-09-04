//
//  TOKBaseView.m
//  Tock
//
//  Created by Rob DeRosa on 6/22/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import "TOKBaseView.h"

@implementation TOKBaseView

@synthesize backgroundColor;
@synthesize backgroundImage;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	if(self.backgroundColor)
	{
		[self.backgroundColor set];
		NSRectFill(self.bounds);
	}
	
	if(self.backgroundImage)
	{
		[self.backgroundImage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	}
}

@end
