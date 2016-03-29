//
//  XYBusyProcessDelegate2.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYProcessResult.h"

/**
 Delegate for busy processing logic
 */
@protocol XYBusyProcessDelegate2 <NSObject>
/**
  Method to turn on busy process indicator
 */
-(void)turnOnBusyFlag;

/**
  Method to turn off busy process indicator
 */
-(void)turnOffBusyFlag;

/**
  Method to handle correct respone
 */
-(void)handleCorrectResponse:(XYProcessResult*) result;

/**
  Method to handle error response
 */
-(void)handleErrorResponse:(XYProcessResult*) result;
@end
