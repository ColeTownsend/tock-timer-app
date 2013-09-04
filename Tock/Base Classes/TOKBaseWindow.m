//
//  TOKBaseWindow.m
//  Tock
//
//  Created by Rob DeRosa on 6/25/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import "TOKBaseWindow.h"
#import "RSCategories.h"

@implementation TOKBaseWindow

-(void)awakeFromNib
{
	self.titleBarHeight = 52;
	self.trafficLightButtonsLeftMargin = 13.0;
	
    self.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect rect, CGPathRef clippingPath)
	{
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        CGContextAddPath(context, clippingPath);
        CGContextClip(context);
		
		CGFloat colors[] =
		{
			228/255.0, 103/255.0, 94/255.0, 1.000,
			244/255.0, 119/255.0, 110/255.0, 1.000
		};
		
		CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
		CGColorSpaceRelease(baseSpace), baseSpace = NULL;
		
		// draw gradient
		CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), rect.size.height - rect.size.height);
		CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), rect.size.height);
		
		CGContextSetBlendMode(context, kCGBlendModeNormal);
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
		
		// release gradient
		CGGradientRelease(gradient), gradient = NULL;
		
		// draw a light horizontal line near the top of the window (3D bevel)
		CGContextSetBlendMode(context, kCGBlendModeNormal);
		CGContextSetStrokeColorWithColor(context, [NSColor colorWithCalibratedWhite:1 alpha:0.50].CGColor);
		CGContextSetLineWidth(context, 1.0);
		
		CGContextMoveToPoint(context, 0, rect.size.height);
		CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
		
		CGContextStrokePath(context);
		
		// draw bottom line darker
		CGContextSetStrokeColorWithColor(context, [NSColor colorWithCalibratedWhite:0 alpha:0.250].CGColor);
		CGContextSetLineWidth(context, 1.0);
		
		CGContextMoveToPoint(context, 0, rect.size.height - rect.size.height);
		CGContextAddLineToPoint(context, rect.size.width, rect.size.height - rect.size.height + 0.5);
		
		CGContextStrokePath(context);
    };
	
	NSTextField* title = [self getLabelWithString:@"TOCK" withFont:[NSFont fontWithName:@"Avenir Next" size:24]];
	NSTextField* titleShadow = [self getLabelWithString:title.stringValue withFont:title.font];
	[titleShadow setTextColor:[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.20f]];
	
	[self.titleBarView addSubview:titleShadow];
	[self.titleBarView addSubview:title];
	
	[title setFrameOrigin:CGPointMake(NSMidX(self.titleBarView.bounds) - (title.frame.size.width / 2), NSMidY(self.titleBarView.bounds) - (title.frame.size.height / 2))];
	[titleShadow setFrameOrigin:CGPointMake(title.frame.origin.x, title.frame.origin.y + 1)];
	
	self.backgroundColor = [NSColor colorWithR:239 G:240 B:243 A:1.0];
}

-(NSTextField*)getLabelWithString:(NSString*)string withFont:(NSFont*)font
{
	CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName]];
	NSTextField* textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, size.width + 4, size.height + 1)];
	[textField setStringValue:string];
	[textField setFont:font];
	[textField setTextColor:[NSColor whiteColor]];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
	
	return textField;
}


@end
