//
//  RSCategories.h
//  Tock
//
//  Created by Rob DeRosa on 6/23/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


//=======================================================================

#pragma mark -
#pragma mark NSString

@interface NSString (RSCategories)

-(NSTimeInterval)toTimeInterval;
-(NSString*)trimWhiteSpace;
-(BOOL)hasValue;
-(NSString*)escape;
-(BOOL)contains:(NSString*)query;
+(NSString*)moneyString:(double)value;
-(BOOL)isValidEmail;
-(BOOL)isValidPassword;

@end

@implementation NSString (RSCategories)

+(NSString*)moneyString:(double)value
{
	NSString* val = [NSString stringWithFormat:@"$%.02f", value];
	
	if([val hasSuffix:@".00"])
		val = [val substringToIndex:val.length - 3];
	
	return val;
}

-(NSTimeInterval)toTimeInterval
{
	NSScanner *scn = [NSScanner scannerWithString:self];
	
    int h, m, s;
    [scn scanInt:&h];
    [scn scanString:@":" intoString:NULL];
    [scn scanInt:&m];
    [scn scanString:@":" intoString:NULL];
    [scn scanInt:&s];
	
    return ((h * 3600) + (m * 60) + s);
}

-(BOOL)contains:(NSString*)query
{
	return [self rangeOfString:query options:NSCaseInsensitiveSearch].location != NSNotFound;
}

-(NSString*)escape
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

-(NSString*)trimWhiteSpace
{
	NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
	
    return [mStr copy];
}

-(BOOL)hasValue
{
	return [self trimWhiteSpace].length > 0;
}

-(NSDate*)toMicroDate
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	return [dateFormatter dateFromString:self];
}

-(NSString*)toTime12
{
	NSScanner* timeScanner = [NSScanner scannerWithString:self];
	int hours, minutes;
	[timeScanner scanInt:&hours];
	[timeScanner scanString:@":" intoString:nil];
	[timeScanner scanInt:&minutes];
	
	NSString* timeOfDay = hours > 12 ? @"pm" : @"am";
	hours = hours > 12 ? hours - 12 : hours;
	return [NSString stringWithFormat:@"%d:%02d%@", hours, minutes, timeOfDay];
}

-(NSString*)safeFileName
{
	NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>:"];
    return [[self componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@"_"];
}

-(BOOL)isValidPassword
{
	return [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
}

-(BOOL)isValidEmail
{
	BOOL stricterFilter = YES;
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:self];
}

@end


//=======================================================================

#pragma mark -
#pragma mark NSView

@interface NSView (RSCategories)

-(void)adjustFrameHeight:(float)height;
-(void)adjustFrameWidth:(float)width;
-(void)adjustFrameY:(float)y;
-(NSView*)findSubViewWithIdentifier:(NSString*)identifier;

@end


@implementation NSView (RSCategories)

-(void)adjustFrameY:(float)y
{
	[self setFrameOrigin:NSMakePoint(self.frame.origin.x, self.frame.origin.y + y)];
}

-(void)adjustFrameHeight:(float)height
{
	[self setFrameSize:NSMakeSize(self.frame.size.width, self.frame.size.height + height)];
}

-(void)adjustFrameWidth:(float)width
{
	[self setFrameSize:NSMakeSize(self.frame.size.width + width, self.frame.size.height)];
}

-(NSView*)findSubViewWithIdentifier:(NSString*)identifier
{
	for(NSView* v in self.subviews)
	{
		if([v.identifier isEqualToString:identifier])
		{
			return v;
		}
	}
	
	return nil;
}

@end


//=======================================================================

#pragma mark -
#pragma mark NSButton

@interface NSButton (RSCategories)

-(void)setTitleColor:(NSColor*)color;

@end

@implementation NSButton (RSCategories)

-(void)setTitleColor:(NSColor*)color
{
	NSMutableAttributedString *colorTitle =	[[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
	NSRange titleRange = NSMakeRange(0, [colorTitle length]);
	[colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
	[self setAttributedTitle:colorTitle];
}

@end


//=======================================================================

#pragma mark -
#pragma mark NSTimer

typedef void (^VoidBlock)();

@interface NSTimer (RSCategories)

- (void)theBlock:(VoidBlock)voidBlock;

@end

@implementation NSTimer (RSCategories)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)theSeconds repeats:(BOOL)repeats actions:(VoidBlock)actions
{
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:@selector(theBlock:)]];
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:theSeconds
                                                   invocation:invocation
                                                      repeats:repeats];
    [invocation setTarget:timer];
    [invocation setSelector:@selector(theBlock:)];
	
	VoidBlock cop = [actions copy];
    [invocation setArgument:&cop atIndex:2];
	
    return timer;
}


- (void)theBlock:(VoidBlock)voidBlock
{
    voidBlock();
}

@end


//=======================================================================

#pragma mark -
#pragma mark NSWindow

@interface NSWindow (RSCategories)

-(void)setFrameSize:(NSSize)size;
-(void)adjustFrameHeight:(float)height;
-(void)adjustFrameWidth:(float)width;

@end

@implementation NSWindow (RSCategories)

-(void)adjustFrameHeight:(float)height
{
	float titleBarHeight =  self.frame.size.height - ((NSView*)self.contentView).frame.size.height;
	[self setFrameSize:NSMakeSize(self.frame.size.width, self.frame.size.height + height - titleBarHeight)];
}

-(void)adjustFrameWidth:(float)width
{
	[self setFrameSize:NSMakeSize(self.frame.size.width + width, self.frame.size.height)];
}

-(void)setFrameSize:(NSSize)size
{
	float titleBarHeight =  self.frame.size.height - ((NSView*)self.contentView).frame.size.height;
	[self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, size.width, size.height + titleBarHeight) display:YES animate:YES];
}

@end

//=======================================================================

#pragma mark -
#pragma mark NSColor

@interface NSColor (RSCategories)

+(NSColor*)colorWithR:(int)R G:(int)G B:(int)B A:(float)A;

@end

@implementation NSColor (RSCategories)

+(NSColor*)colorWithR:(int)R G:(int)G B:(int)B A:(float)A
{
	return [NSColor colorWithCalibratedRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A];
}

+(NSColor*)colorWithRGB:(CGFloat[4])values
{
	return [NSColor colorWithR:values[0] G:values[1] B:values[2] A:values[3]];
}

@end


//=======================================================================

#pragma mark -
#pragma mark NSDate

@interface NSDate (RSCategories)

-(NSString*)toString;
-(NSString*)toShortString;
-(NSString*)toTimeString;
+(NSString*)timeIntervalToString:(NSTimeInterval)interval;

@end

@implementation NSDate (Extensions)

+(NSString*)timeIntervalToString:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}


-(NSString*)toString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	return [dateFormatter stringFromDate:self];
}

-(long)daysSinceDate:(NSDate*)date
{
	NSTimeInterval lastDiff = [self timeIntervalSinceNow];
	NSTimeInterval todaysDiff = [date timeIntervalSinceNow];
	NSTimeInterval dateDiff = lastDiff - todaysDiff;
	
	float days = dateDiff / 60 / 60 / 24;
	return floor(days) * -1;
}

-(NSDate*)toShortDate
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM dd, yyyy"];
	NSString *dateString = [format stringFromDate:self];
	
	NSDate* inDate = [format dateFromString:dateString];
	return inDate;
}

-(NSString*)toMicroString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	return [dateFormatter stringFromDate:self];
}

-(NSString*)toMicroWithTimeString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
	return [dateFormatter stringFromDate:self];
}

-(NSString*)toShortString
{
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setDateFormat:@"MMM d"];
	return [dateFormatter stringFromDate:self];
}

-(NSString*)toShortStringWithTime
{
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setDateFormat:@"MMM d h:mm a"];
	return [dateFormatter stringFromDate:self];
}

-(NSString*)toLongString
{
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
	return [dateFormatter stringFromDate:self];
}

@end





@implementation NSApplication (SheetAdditions)

- (void)beginSheet: (NSWindow *)sheet modalForWindow:(NSWindow *)docWindow didEndBlock: (void (^)(NSInteger returnCode))block
{
	[self beginSheet: sheet
	  modalForWindow: docWindow
	   modalDelegate: self
	  didEndSelector: @selector(my_blockSheetDidEnd:returnCode:contextInfo:)
		 contextInfo: (__bridge void *)([block copy])];
}

- (void)my_blockSheetDidEnd: (NSWindow *)sheet returnCode: (NSInteger)returnCode contextInfo: (void *)contextInfo
{
	void (^block)(NSInteger returnCode) = (__bridge void (^)(NSInteger))(contextInfo);
	block(returnCode);
}

@end
