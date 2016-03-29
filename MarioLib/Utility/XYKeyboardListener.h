//
//  XYKeyboardListener.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 12/17/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 This class is used to check whether keyboard is displayed
 */
@interface XYKeyboardListener : NSObject

/**
 Indicate whether keyboard is visible
 */
@property(nonatomic,readonly) BOOL visible;

/**
 Singleton method to get instance
 */
+(XYKeyboardListener*)instance;
@end
