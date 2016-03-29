//
//  XYStatusUpdateDelegate.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/30/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Delegate for status updater
 */
@protocol XYStatusUpdateDelegate <NSObject>
@required
/**
 Log/Output string value
 */
-(void)log:(NSString*)status;

/**
 Log/Output progress value
 */
-(void)progress:(NSNumber*)progress;


@optional
/**
 Log/Output substring value
 */
-(void)subLog:(NSString*)status;
/**
 Log/Output subprogress value
 */
-(void)subProgress:(NSNumber*)progress;
@end
