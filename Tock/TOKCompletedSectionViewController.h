//
//  TOKCompletedSectionViewController.h
//  Tock
//
//  Created by Rob DeRosa on 6/22/13.
//  Copyright (c) 2013 Rob DeRosa. All rights reserved.
//  Design copyright 2013 by Cole Townsend
//

#import <Cocoa/Cocoa.h>
#import "TOKTask.h"

@interface TOKCompletedSectionViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>


@end


@interface TOKCompletedTaskItemCellView : NSTableCellView

@property BOOL isLast;
@property BOOL isSelected;

-(NSTextField*)getTaskName;
-(NSTextField*)getTaskCost;
-(NSTextField*)getTaskTime;

@end
