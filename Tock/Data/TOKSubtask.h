//
//  TOKSubtask.h
//  Tock
//
//  Created by Rob DeRosa on 7/1/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import <ParseOSX/ParseOSX.h>
#import "TOKTask.h"

@interface TOKSubtask : PFObject<PFSubclassing>

@property BOOL isComplete;
@property (strong) NSString* name;
@property (strong) TOKTask* parentTask;

@end
