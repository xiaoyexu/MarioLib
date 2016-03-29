//
//  XYProcessResult.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDesighHeader.h"

/**
 This class represents a process result
 It contains flag for success or not and a NSDictionary to store more info
 */
@interface XYProcessResult : NSObject

/**
 Flag whether process result is success
 */
@property (nonatomic) BOOL success;

/**
 NSString value for process type
 */
@property (nonatomic) NSString* type;

/**
 NSDictionary for parameters
 */
@property (nonatomic,strong) NSDictionary* params;

/**
 NSString for which segue identifier is used
 */
@property (nonatomic,strong) NSString* forwardSegueIdentifer;

/**
 Initalization method
 */
-(id)init;

/**
 Static method to create a success XYProcessResult object
 */
+(XYProcessResult*)success;

/**
 Static method to create a failure XYProcessResult object
 */
+(XYProcessResult*)failure;
@end
