//
//  TOKSubtask.m
//  Tock
//
//  Created by Rob DeRosa on 7/1/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import "TOKSubtask.h"

@implementation TOKSubtask

@dynamic name;
@dynamic isComplete;
@dynamic parentTask;

+(NSString*)parseClassName
{
	return @"Subtask";
}

@end
