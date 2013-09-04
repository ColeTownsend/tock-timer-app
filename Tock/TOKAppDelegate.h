//
//  TOKAppDelegate.h
//  Tock
//
//  Created by Rob DeRosa on 6/20/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//  Design copyright 2013 by Cole Townsend
//

#import <Cocoa/Cocoa.h>
#import <ParseOSX/ParseOSX.h>
#import "TOKGlobals.h"
#import "TOKTask.h"
#import "TOKSettings.h"

@interface TOKAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (strong) TOKSettings* settings;
@property (strong) NSMutableArray* tasks;
@property (strong, nonatomic) TOKTask* selectedTask;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)notifyUserAuthenticated;
-(void)ensureSubtasksLoaded:(TOKTask*)task;
-(void)addNewTask:(TOKTask*)task;

+(void)runOnMainQueue:(void(^)(void))block;
+(void)runOnMainQueue:(float)afterInterval :(void(^)(void))block;
+(void)runOnSeperateQueue:(void(^)(void))block;
+(void)runOnSeperateQueue:(float)afterInterval :(void(^)(void))block;

@end

extern TOKAppDelegate* g_AppDelegate;