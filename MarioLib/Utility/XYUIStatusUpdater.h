//
//  XYUIStatusUpdater.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYStatusUpdateDelegate.h"
#import <UIKit/UIKit.h>

/**
 This class represents an updater
 It is used to display processing data in a pure non-ui related logic block
 */
@interface XYUIStatusUpdater : NSObject
@property (nonatomic,strong) id updater;

/**
 Initialization method with and object
 @param obj The object that contains a setText: method, can be a UILabel or UITextfield
 */
-(id)initWith:(id)obj;

/**
 Initialization method with an object has XYStatusUpdateDelegate implemented
 @param obj Object that implemented XYStatusUpdateDelegate method
 */
-(id)initWithDelegate:(id<XYStatusUpdateDelegate>)obj;

/**
 Output text
 @param str String to display
 */
-(void)log:(NSString*)str;

/**
 Output text
 Only for XYStatusUpdateDelegate object
 @param str Substring to display
 */
-(void)subLog:(NSString*)str;

/**
 Resume previous text before updating
 Incase updater has original text, this method will resume text
 */
-(void)endLog;

/**
 Set float value for progress if obj contains a setProgress method or delegate implemented
 @param progress Float value for progress
 */
-(void)progress:(float)progress;

/**
 Set float value for subprogress
 Only for XYStatusUpdateDelegate object
 @param progress Float value for progress
 */
-(void)subProgress:(float)progress;
@end
