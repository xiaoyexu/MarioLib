//
//  XYBaseErrorCenter.h
//  XYUIDesign
//
//  Created by Xu, Xiaoye on 11/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYErrorInfo.h"
#import "XYStorageManager.h"

/**
 This class handle all error recording
 */
@interface XYBaseErrorCenter : NSObject

/**
 Size of records store on user's device
 */
@property (nonatomic) NSUInteger reserveErrorSize;

/**
 Debug log flag
 If flag is YES, no limitation for log size, and everything logged by recordDebugInfo: will be included
 */
@property (nonatomic) BOOL debugMode;

/**
 Singleton method to get XYBaseErrorCenter instance
 */
+(XYBaseErrorCenter*) instance;

/**
 Write logs to file "CFBundleIdentifier".error file
 */
-(void)recordError:(XYErrorInfo*)errorInfo;
-(void)recordErrorWithTitle:(NSString*)title detail:(NSString*)detail;
-(void)recordErrorWithTitle:(NSString*)title detail:(NSString*)detail level:(XYErrorLevel)level;
-(void)recordDebugInfo:(NSString*)info;
-(void)cleanAll;
-(NSData*)errorListData;
-(NSArray*)errorList;

@end
