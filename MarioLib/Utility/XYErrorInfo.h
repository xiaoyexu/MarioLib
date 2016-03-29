//
//  XYErrorInfo.h
//  XYUIDesign
//
//  Created by Xu, Xiaoye on 11/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    XYErrorLevelLow,
    XYErrorLevelMedium,
    XYErrorLevelHigh,
    XYErrorLevelFatal,
} XYErrorLevel;

/**
 This class represents a error record
 */
@interface XYErrorInfo : NSObject <NSCoding>

/**
 Error title
 */
@property(nonatomic, strong) NSString* title;

/**
 Error level
 */
@property(nonatomic) XYErrorLevel level;

/**
 Error detail
 */
@property(nonatomic, strong) NSString* detail;

/**
 NSDate for error time
 */
@property(nonatomic, strong) NSDate* timestamp;

/**
 Initialization method
 */
-(id)init;

/**
 Initialization method with title and detail
 @param title Title of error
 @param detail Detail of error
 */
-(id)initWithTitle:(NSString*)title detail:(NSString*)detail;

/**
 Initialization method with title, detail and level
 @param title Title of error
 @param detail Detail of error
 @param level Error level
 */
-(id)initWithTitle:(NSString*)title detail:(NSString*)detail level:(XYErrorLevel)level;
@end
