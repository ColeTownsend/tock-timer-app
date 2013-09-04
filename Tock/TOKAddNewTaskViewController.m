//
//  TOKAddNewTaskViewController.m
//  Tock
//
//  Created by Rob DeRosa on 6/24/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import <ParseOSX/ParseOSX.h>
#import "TOKAddNewTaskViewController.h"
#import "RSCategories.h"
#import "TOKAppDelegate.h"
#import "TOKBaseView.h"
#import "TOKTask.h"

@interface TOKAddNewTaskViewController ()

@property (weak) IBOutlet NSButton *cancelButton;

@end

@implementation TOKAddNewTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
		TOKBaseView* baseView = (TOKBaseView*)self.view;
		baseView.backgroundColor = [NSColor colorWithR:249 G:249 B:249 A:1];
    }
    
    return self;
}

-(void)awakeFromNib
{
	[_cancelButton setTitleColor:[NSColor colorWithRGB:MED_GRAY]];
}

-(void)reset
{
	_addNewTaskTextField.stringValue = @"";
	[self.view removeFromSuperview];
}

-(BOOL)control:(NSControl*)control textView:(NSTextView*)fieldEditor doCommandBySelector:(SEL)commandSelector
{
    BOOL isReturn = commandSelector == @selector(insertNewline:);
	
	if(isReturn)
	{
		if(control == _addNewTaskTextField)
		{
			[self onNewTaskSubmit];
		}
	}
	
	return isReturn;
}

-(BOOL)becomeFirstResponder
{
	[_addNewTaskTextField becomeFirstResponder];
	return YES;
}

-(void)onNewTaskSubmit
{
	TOKTask* task = [TOKTask object];
	task.name = [_addNewTaskTextField.stringValue trimWhiteSpace];
	task.index = 0;
	task.time = 0;
	task.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
	[self reset];

	[g_AppDelegate addNewTask:task];
}

- (IBAction)onCancelClick:(id)sender
{
	[self reset];
}

@end
