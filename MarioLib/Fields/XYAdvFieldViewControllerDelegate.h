//
//  XYAdvFieldViewControllerDelegate.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/14/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAdvField.h"
@class XYAdvField;

/**
 XYAdvField view controller delegate
 */
@protocol XYAdvFieldViewControllerDelegate <NSObject>
@required
/**
 Required method to store XYAdvField instance
 */
@property(nonatomic,strong) XYAdvField* advField;

/**
 Method to refresh the screen based on XYAdvField
 */
-(void)loadAdvFieldValue;
@end
