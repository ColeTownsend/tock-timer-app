//
//  TOKTask.m
//  Tock
//
//  Created by Rob DeRosa on 6/30/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import "TOKTask.h"
#import <ParseOSX/ParseOSX.h>

@implementation TOKTask

@dynamic name;
@dynamic index;
@dynamic subTasks;
@dynamic time;
@dynamic isComplete;

+(NSString*)parseClassName
{
	return @"Task";
}

@end
