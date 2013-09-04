//
//  TOKCompletedSectionViewController.m
//  Tock
//
//  Created by Rob DeRosa on 6/22/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//  Design copyright 2013 by Cole Townsend
//

#import "TOKCompletedSectionViewController.h"
#import <ParseOSX/ParseOSX.h>
#import "RSCategories.h"
#import "TOKAppDelegate.h"
#import "TOKBaseView.h"

@interface TOKCompletedSectionViewController ()
{
}

@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation TOKCompletedSectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
	{
    }
    
    return self;
}

-(void)awakeFromNib
{
	[super awakeFromNib];
	[self bindNotificationListeners];
}

-(void)bindNotificationListeners
{
	[[NSNotificationCenter defaultCenter] addObserverForName:TOKNEW_TASK_ADDED
													  object: nil
													   queue: [NSOperationQueue mainQueue]
												  usingBlock: ^(NSNotification *notification)
	 {
		 [_tableView reloadData];
	 }];
}

-(BOOL)becomeFirstResponder
{
	[self.tableView reloadData];
	[self updateSelectedTask];
	return [super becomeFirstResponder];
}

-(void)updateSelectedTask
{
	long index = 0;
	for(TOKTask* t in g_AppDelegate.tasks)
	{
		if(t == g_AppDelegate.selectedTask)
			break;
		
		index++;
	}
	
	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
	[self.tableView selectRowIndexes:indexSet byExtendingSelection:NO];
}

-(void)setSelectedTask:(TOKTask *)task
{
	g_AppDelegate.selectedTask = task;
	//[self.tableView reloadData];
}

-(long)numberOfRowsInTableView:(NSTableView *)tableView
{
	return g_AppDelegate.tasks.count;
}

-(NSTableRowView*)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
	NSTableRowView* r = [NSTableRowView new];
	return r;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if(row >= g_AppDelegate.tasks.count)
		return nil;
	
	NSTableRowView* rowView = [tableView rowViewAtRow:row makeIfNecessary:NO];
	//[view.imageView setHidden:!rowView.selected];

	TOKTask* obj = [g_AppDelegate.tasks objectAtIndex:row];
	TOKCompletedTaskItemCellView* view = [tableView makeViewWithIdentifier:@"taskItemView" owner:nil];
	view.isLast = row == g_AppDelegate.tasks.count - 1;
	view.objectValue = obj;

	double hourlyRate = [[g_AppDelegate.settings objectForKey:@"hourlyRate"] floatValue];
	double secondlyRate = hourlyRate / 60 / 60;
	double totalCost = secondlyRate * obj.time;
	
	[view getTaskName].stringValue = [obj.name uppercaseString];
	[view getTaskTime].stringValue = [NSDate timeIntervalToString:obj.time];
	[view getTaskCost].stringValue = [NSString moneyString:totalCost];
	
	NSImage* img = nil;
	
	if(obj.isComplete)
		img = [NSImage imageNamed:@"completed annotation"];

	if(g_AppDelegate.selectedTask == obj)
	{
		view.isSelected = YES;
		rowView.selected = YES;
		img = [NSImage imageNamed:@"active annotation"];
	}
	
	((NSImageView*)[view findSubViewWithIdentifier:@"stateImage"]).image = img;
	NSButton* btn = (NSButton*)[view findSubViewWithIdentifier:@"deleteButton"];
	btn.target = self;
	[btn setAction:@selector(onDeleteButtonClicked:)];
	
	return view;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
	return YES;
}

-(NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes
{
	return proposedSelectionIndexes;
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification
{
	[_tableView enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row)
	 {
		 TOKCompletedTaskItemCellView *cellView = [rowView viewAtColumn:0];
		 [cellView.imageView setHidden:YES];
		 cellView.isSelected = rowView.selected;
		 NSLog(@"Row: %lu", row);

		 if(rowView.selected)
		 {
			 [cellView.imageView setHidden:NO];
			 [self setSelectedTask:g_AppDelegate.tasks[row]];
		 }
		 
		 [cellView setNeedsDisplay:YES];
	 }];
}

-(IBAction)onDeleteButtonClicked:(NSButton *)sender
{
	TOKTask* item = [((NSTableCellView*)[sender superview]) objectValue];
	long index = [g_AppDelegate.tasks indexOfObject:item];
	NSIndexSet* set = [[NSIndexSet alloc] initWithIndex:index];
	[self.tableView removeRowsAtIndexes:set withAnimation:NSTableViewAnimationSlideUp];
	
	[g_AppDelegate.tasks removeObject:item];
	[item deleteInBackground];
}

@end



@interface TOKCompletedTaskItemCellView()
{
	NSTrackingArea *trackingArea;
}

@end

@implementation TOKCompletedTaskItemCellView

@synthesize isLast;
@synthesize isSelected;

-(NSTextField*)getTaskName
{
	return (NSTextField*)[self findSubViewWithIdentifier:@"taskName"];
}

-(NSTextField*)getTaskTime
{
	return (NSTextField*)[self findSubViewWithIdentifier:@"taskTime"];
}

-(NSTextField*)getTaskCost
{
	return (NSTextField*)[self findSubViewWithIdentifier:@"taskCost"];
}

- (void)ensureTrackingArea
{
    if (trackingArea == nil) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    [self ensureTrackingArea];
    if (![[self trackingAreas] containsObject:trackingArea])
	{
        [self addTrackingArea:trackingArea];
    }
}

-(void)mouseEntered:(NSEvent *)theEvent
{
	NSButton* b = (NSButton*)[self findSubViewWithIdentifier:@"deleteButton"];
	[b setHidden:NO];
}

-(void)mouseExited:(NSEvent *)theEvent
{
	NSButton* b = (NSButton*)[self findSubViewWithIdentifier:@"deleteButton"];
	[b setHidden:YES];
}

-(void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSetBlendMode(context, kCGBlendModeNormal);
	CGContextSetShouldAntialias (context, FALSE);

	CGContextSetFillColorWithColor(context, self.isSelected ? [NSColor colorWithR:255 G:255 B:255 A:1].CGColor : [NSColor colorWithR:249 G:249 B:249 A:1].CGColor);
	CGContextFillRect(context, dirtyRect);

	CGContextSetStrokeColorWithColor(context, [NSColor colorWithR:215 G:215 B:215 A:1].CGColor);
	CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, 0, dirtyRect.size.height - 1);
	CGContextAddLineToPoint(context, dirtyRect.size.width, dirtyRect.size.height - 1);
	CGContextStrokePath(context);
	
	if(self.isLast)
	{
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, dirtyRect.size.width, 0);
		CGContextStrokePath(context);
	}
}

@end




@interface TOKCompletedView : TOKBaseView
{
}
@end

@implementation TOKCompletedView

-(void)awakeFromNib
{
	[super awakeFromNib];
	self.backgroundColor = [NSColor colorWithR:239 G:240 B:243 A:1.0];
}

-(void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];

	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSetBlendMode(context, kCGBlendModeNormal);
	CGContextSetShouldAntialias (context, FALSE);
//	CGContextSetFillColorWithColor(context, [NSColor colorWithR:249 G:249 B:249 A:1].CGColor);
//	CGContextFillRect(context, NSMakeRect(0, self.bounds.size.height - 100, self.bounds.size.width, 100));
	
	CGContextSetStrokeColorWithColor(context, [NSColor colorWithR:215 G:215 B:215 A:1].CGColor);
	CGContextSetLineWidth(context, 1.0);
	
	CGContextMoveToPoint(context, 0, self.bounds.size.height - 1);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
	CGContextStrokePath(context);
}

@end