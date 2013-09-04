//
//  TOKAuthenticationWindowController.m
//  Tock
//
//  Created by Rob DeRosa on 6/25/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import "TOKAuthenticationWindowController.h"
#import "RSCategories.h"
#import "TOKBaseView.h"
#import "TOKAppDelegate.h"
#import <ParseOSX/ParseOSX.h>

@interface TOKAuthenticationWindowController ()

@property (strong) IBOutlet NSButton *forgotPasswordButton;
@property (strong) IBOutlet TOKBaseView *initialView;
@property (strong) IBOutlet TOKBaseView *signUpView;
@property (strong) IBOutlet TOKBaseView *logInView;
@property (strong) IBOutlet TOKBaseView *forgotPasswordView;
@property (strong) IBOutlet NSTextField *signUpEmailTextField;
@property (strong) IBOutlet NSSecureTextField *signUpPasswordTextField;
@property (strong) IBOutlet NSImageView *signUpEmailTextBackground;
@property (strong) IBOutlet NSImageView *signUpPasswordTextBackground;
@property (strong) IBOutlet NSButton *facebookSignUpButton;
@property (strong) IBOutlet NSTextField *signUpErrorLabel;
@property (strong) IBOutlet NSButton *signUpButton;
@property (strong) IBOutlet NSImageView *signUpTimerIcon;
@property (strong) IBOutlet NSTextField *logInEmailTextField;
@property (strong) IBOutlet NSSecureTextField *logInPasswordTextField;
@property (strong) IBOutlet NSButton *facebookLogInButton;
@property (strong) IBOutlet NSButton *logInButton;
@property (strong) IBOutlet NSImageView *logInPasswordTextBackground;
@property (strong) IBOutlet NSImageView *logInEmailTextBackground;
@property (strong) IBOutlet NSImageView *logInTimerIcon;
@property (strong) IBOutlet NSTextField *logInErrorLabel;
@property (strong) IBOutlet NSTextField *forgotEmailTextField;
@property (strong) IBOutlet NSImageView *forgotEmailTextBackground;
@property (strong) IBOutlet NSButton *sendButton;
@property (strong) IBOutlet NSImageView *forgotTimerIcon;
@property (strong) IBOutlet NSTextField *forgotErrorLabel;
@property (strong) IBOutlet NSButton *logInBackButton;
@property (strong) IBOutlet NSButton *sendBackButton;
@property (strong) IBOutlet NSButton *signUpBackButton;

@end

@implementation TOKAuthenticationWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if(self)
	{
	}

    return self;
}

-(void)setView:(TOKBaseView*)view;
{
	if(!view.originalHeight)
		view.originalHeight = view.frame.size.height;
	
	[self.window setFrameSize:NSMakeSize(view.frame.size.width, view.originalHeight)];
	self.window.contentView = view;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	
	NSColor* c = [NSColor colorWithR:249 G:249 B:249 A:1];
	_signUpView.backgroundColor = c;
	_logInView.backgroundColor = c;
	_initialView.backgroundColor = c;
	_forgotPasswordView.backgroundColor = c;

	NSColor* g = [NSColor colorWithR:190 G:190 B:190 A:1];
	[_forgotPasswordButton setTitleColor:g];
	[_logInBackButton setTitleColor:g];
	[_signUpBackButton setTitleColor:g];
	[_sendBackButton setTitleColor:g];

#if DEBUG
	_logInEmailTextField.stringValue = @"derosa@gmail.com";
	_logInPasswordTextField.stringValue = @"Counter8";
#endif
	
	[self setView:_initialView];
}

-(void)windowWillClose:(id)sender
{
	if(![PFUser currentUser].email)
	{
		[[NSApplication sharedApplication] terminate:self];
	}
}

- (IBAction)onSignUpSectionClicked:(id)sender
{
	[self setView:_signUpView];
	[_signUpEmailTextField becomeFirstResponder];
}

- (IBAction)onLogInSectionClicked:(id)sender
{
	[self setView:_logInView];
	[_logInEmailTextField becomeFirstResponder];
}

- (IBAction)onForgotPasswordButtonClicked:(id)sender
{
	[self setView:_forgotPasswordView];
	[_forgotEmailTextField becomeFirstResponder];
}

- (IBAction)onSignUpClicked:(id)sender
{
	if(!_facebookSignUpButton.isHidden)
	{
		[_facebookSignUpButton setHidden:YES];
		float heightDiff = _facebookSignUpButton.frame.size.height;
		[self.window adjustFrameHeight:heightDiff * -1];
		
		[_signUpEmailTextBackground adjustFrameY:heightDiff];
		[_signUpEmailTextField adjustFrameY:heightDiff];
		[_signUpPasswordTextBackground adjustFrameY:heightDiff];
		[_signUpPasswordTextField adjustFrameY:heightDiff];
		[_signUpButton adjustFrameY:heightDiff];
		[_signUpBackButton adjustFrameY:heightDiff];
		[_signUpView setFrameOrigin:NSMakePoint(0, 0)];
		_signUpView.originalHeight -= heightDiff;
	}

	_signUpErrorLabel.stringValue = @"";
	_signUpTimerIcon.image = [NSImage imageNamed:@"timer icon inactive"];

	if(![[_signUpEmailTextField.stringValue trimWhiteSpace] isValidEmail])
	{
		_signUpTimerIcon.image = [NSImage imageNamed:@"timer icon active"];
		_signUpEmailTextBackground.image = [NSImage imageNamed:@"auth textbox invalid"];
		_signUpErrorLabel.stringValue = @"Please enter a valid email.";
		[_signUpErrorLabel setHidden:NO];
		return;
	}
	else
	{
		_signUpEmailTextBackground.image = [NSImage imageNamed:@"auth textbox"];
	}

	if(![_signUpPasswordTextField.stringValue isValidPassword])
	{
		_signUpTimerIcon.image = [NSImage imageNamed:@"timer icon active"];
		_signUpPasswordTextBackground.image = [NSImage imageNamed:@"auth textbox invalid"];
		_signUpErrorLabel.stringValue = @"Please add at least one number.";
		[_signUpErrorLabel setHidden:NO];
		return;
	}
	else
	{
		_signUpPasswordTextBackground.image = [NSImage imageNamed:@"auth textbox"];
	}
	
	[self registerUser];
}

-(void)registerUser
{
	PFUser *user = [PFUser user];
    user.username = [_signUpEmailTextField.stringValue trimWhiteSpace];
    user.password = _signUpPasswordTextField.stringValue;
    user.email = user.username;
	[_signUpErrorLabel setHidden:NO];
	_signUpErrorLabel.stringValue = @"Signing up...";
	
	[_signUpEmailTextField setEnabled:NO];
	[_signUpPasswordTextField setEnabled:NO];
	[_signUpButton setEnabled:NO];
	
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if(!error)
		{
			_signUpErrorLabel.stringValue = @"Sign up complete!";
			
			[TOKAppDelegate runOnMainQueue:0.5 :^
			 {
				 [g_AppDelegate notifyUserAuthenticated];
				 [self.window close];
			 }];
		}
		else
		{
			NSString *errorString = [[error userInfo] objectForKey:@"error"];
			if([[[error userInfo] objectForKey:@"code"] intValue] == 202)
			{
				errorString = @"That email is already in use.";
				[_signUpEmailTextField becomeFirstResponder];
			}
			
			_signUpTimerIcon.image = [NSImage imageNamed:@"timer icon active"];
			_signUpErrorLabel.stringValue = errorString;
			
			[_signUpEmailTextField setEnabled:YES];
			[_signUpPasswordTextField setEnabled:YES];
			[_signUpButton setEnabled:YES];

			NSLog(@"Error for user sign up - %@", error);
		}
    }];
}

- (IBAction)onLogInClicked:(id)sender
{
	[self shortenLoginHeight];
	_logInErrorLabel.stringValue = @"";
	_logInTimerIcon.image = [NSImage imageNamed:@"timer icon inactive"];
	
	if(![_logInEmailTextField.stringValue isValidEmail])
	{
		_logInTimerIcon.image = [NSImage imageNamed:@"timer icon active"];
		_logInEmailTextBackground.image = [NSImage imageNamed:@"auth textbox invalid"];
		_logInErrorLabel.stringValue = @"Please enter a valid email.";
		[_logInErrorLabel setHidden:NO];
		return;
	}
	else
	{
		_logInEmailTextBackground.image = [NSImage imageNamed:@"auth textbox"];
	}
		
	[self logInUser];
}

-(void)shortenLoginHeight
{
	if(!_facebookLogInButton.isHidden)
	{
		[_facebookLogInButton setHidden:YES];
		float heightDiff = _facebookLogInButton.frame.size.height;
		[self.window adjustFrameHeight:heightDiff * -1];
		
		[_logInEmailTextBackground adjustFrameY:heightDiff];
		[_logInEmailTextField adjustFrameY:heightDiff];
		[_logInPasswordTextBackground adjustFrameY:heightDiff];
		[_logInPasswordTextField adjustFrameY:heightDiff];
		[_logInButton adjustFrameY:heightDiff];
		[_forgotPasswordButton adjustFrameY:heightDiff];
		[_logInBackButton adjustFrameY:heightDiff];
		[_logInView setFrameOrigin:NSMakePoint(0, 0)];
		_logInView.originalHeight -= heightDiff;
	}
}

-(void)logInUser
{
	[_logInEmailTextField setEnabled:NO];
	[_logInPasswordTextField setEnabled:NO];
	[_logInButton setEnabled:NO];

	[_logInErrorLabel setHidden:NO];
	_logInErrorLabel.stringValue = @"Logging in...";
	
	NSString* email = [_logInEmailTextField.stringValue trimWhiteSpace];
	NSString* password = _logInPasswordTextField.stringValue;
	
	[PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error)
	{
		if(user)
		{
			_logInErrorLabel.stringValue = @"Log in complete!";
			[TOKAppDelegate runOnMainQueue:0.5 :^
			 {
				 [g_AppDelegate notifyUserAuthenticated];
				 [self.window close];
			 }];
		}
		else
		{
			NSString *errorString = [[error userInfo] objectForKey:@"error"];
			if([[[error userInfo] objectForKey:@"code"] intValue] == 101)
			{
				errorString = @"Invalid credentials.";
				[_logInEmailTextField becomeFirstResponder];
			}
			
			_logInTimerIcon.image = [NSImage imageNamed:@"timer icon active"];
			_logInErrorLabel.stringValue = errorString;
			
			[_logInEmailTextField setEnabled:YES];
			[_logInPasswordTextField setEnabled:YES];
			[_logInButton setEnabled:YES];
			
			NSLog(@"Error for user log in - %@", error);
		}
	 }];
}

- (IBAction)onSendClick:(id)sender
{
	NSString* email = [_forgotEmailTextField.stringValue trimWhiteSpace];
	
	_forgotErrorLabel.stringValue = @"";
	_forgotTimerIcon.image = [NSImage imageNamed:@"timer icon inactive"];
	_forgotErrorLabel.textColor = [NSColor colorWithRGB:DARK_GRAY];
	_forgotEmailTextBackground.image = [NSImage imageNamed:@"auth textbox"];
	
	if(![email isValidEmail])
	{
		_forgotTimerIcon.image = [NSImage imageNamed:@"timer icon active"];
		_forgotEmailTextBackground.image = [NSImage imageNamed:@"auth textbox invalid"];
		_forgotErrorLabel.stringValue = @"Please enter a valid email.";
		_forgotErrorLabel.textColor = [NSColor colorWithRGB:APP_RED];
		[_forgotErrorLabel setHidden:NO];
		return;
	}

	[self sendResetPassword:email];
}

-(void)sendResetPassword:(NSString*)email
{
	[_forgotEmailTextField setEnabled:NO];
	[_sendButton setEnabled:NO];
	
	[_forgotErrorLabel setHidden:NO];
	_forgotErrorLabel.stringValue = @"Sending password reset email...";

	[PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error)
	{
		if(succeeded)
		{
			_forgotErrorLabel.stringValue = @"Please check your email.";
			[TOKAppDelegate runOnMainQueue:2.0 :^
			 {
				 _logInErrorLabel.stringValue = @"Please check your email.";
				 [_logInErrorLabel setHidden:NO];
				 [self shortenLoginHeight];
				 [self setView:_logInView];
			 }];
		}
		else
		{
			NSString *errorString = [[error userInfo] objectForKey:@"error"];
			if([[[error userInfo] objectForKey:@"code"] intValue] == 205)
			{
				errorString = @"That email was not found.";
				[_forgotEmailTextField becomeFirstResponder];
			}
			
			_forgotTimerIcon.image = [NSImage imageNamed:@"timer icon active"];
			_forgotErrorLabel.stringValue = errorString;
			_forgotEmailTextBackground.image = [NSImage imageNamed:@"auth textbox invalid"];
			_forgotErrorLabel.textColor = [NSColor colorWithRGB:APP_RED];
			
			[_forgotEmailTextField setEnabled:YES];
			[_sendButton setEnabled:YES];
			
			NSLog(@"Error for user send password reset - %@", error);
		}
	}];
}

-(BOOL)control:(NSControl*)control textView:(NSTextView*)fieldEditor doCommandBySelector:(SEL)commandSelector
{
    BOOL isReturn = commandSelector == @selector(insertNewline:);
	
	if(isReturn)
	{
		if(control == _signUpEmailTextField || control == _signUpPasswordTextField)
		{
			[self onSignUpClicked:nil];
		}
		
		if(control == _logInEmailTextField || control == _logInPasswordTextField)
		{
			_logInPasswordTextField.stringValue = _logInPasswordTextField.stringValue;
			[self onLogInClicked:nil];
		}
		
		if(control == _forgotEmailTextField)
		{
			[self onSendClick:nil];
		}
	}
	
	return isReturn;
}

- (IBAction)onLogInBackClicked:(id)sender
{
	NSLog(@"View Size: %f", _initialView.frame.size.height);
	[self setView:_initialView];
}

- (IBAction)onSendBackClicked:(id)sender
{
	NSLog(@"View Size: %f", _logInView.frame.size.height);
	//[_logInView setFrameSize:NSMakeSize(_logInView.frame.size.width, 428)];
	[self setView:_logInView];
}

- (IBAction)onSignUpBackClicked:(id)sender
{
	//[_initialView setFrameSize:NSMakeSize(_initialView.frame.size.width, 400)];
	[self setView:_initialView];
}

@end
