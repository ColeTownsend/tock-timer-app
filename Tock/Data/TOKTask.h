//
//  TOKTask.h
//  Tock
//
//  Created by Rob DeRosa on 6/30/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseOSX/ParseOSX.h>
#import "RSCategories.h"

@interface TOKTask : PFObject<PFSubclassing>

@property (strong) NSString* name;
@property (strong) NSMutableArray* subTasks;
@property NSTimeInterval time;
@property BOOL isComplete;
@property int index;

@end
