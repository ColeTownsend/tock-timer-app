//
//  TOKBaseWindow.m
//  Tock
//
//  Created by Rob DeRosa on 6/20/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//  Design copyright 2013 by Cole Townsend
//

#import "TOKMainWindow.h"
#import "TOKBaseView.h"
#import "RSCategories.h"
#import "TOKGlobals.h"

#import <objc/runtime.h>

@interface TOKMainWindow()

@property (weak) IBOutlet NSButton *activeButton;
@property (weak) IBOutlet NSButton *completedButton;

@end

@implementation TOKMainWindow

- (void)awakeFromNib
{
    [super awakeFromNib];
	
	int width = 91;
	int height = 39;
	int padding = 8;

	NSButton* newTaskButton = [NSButton new];
	[newTaskButton setButtonType:NSMomentaryChangeButton];
	[newTaskButton setBordered:NO];
	newTaskButton.image = [NSImage imageNamed:@"new task"];
	newTaskButton.alternateImage = [NSImage imageNamed:@"new task active"];
	[newTaskButton setAction:@selector(newTaskButtonClicked:)];

	newTaskButton.frame = CGRectMake(self.titleBarView.bounds.size.width - width - padding, self.titleBarView.bounds.size.height - height - padding, width, height);
	[self.titleBarView addSubview:newTaskButton];
}

-(void)newTaskButtonClicked:(NSButton*)sender
{
	NSNotification* n = [NSNotification notificationWithName:TOKNEW_TASK_REQUESTED object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

@end