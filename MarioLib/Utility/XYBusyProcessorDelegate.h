//
//  XYBusyProcessorDelegate.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYProcessResult.h"
#import "XYUIStatusUpdater.h"

/**
 Delegate for busy processor
 */
@protocol XYBusyProcessorDelegate <NSObject>
/**
  NSString for the title of busy process
 */
@property (strong, nonatomic) NSString* busyProcessTitle;

/**
  Flag whether to show busy process indicator
 */
@property (nonatomic) BOOL showActivityIndicatorView;

/**
  Method to run busy process block
 */
-(void)performBusyProcess:(XYProcessResult*(^)(void))block;

/**
  Method to run busy process with updater
 */
-(void)performBusyProcessWithUpdater:(XYProcessResult*(^)(XYUIStatusUpdater* updater))block;

/**
  Method to run busy process selector
 */
-(void)performBusyProcessSEL:(SEL) selector ofTarget:(id) target withObject:(id)obj;
@end
