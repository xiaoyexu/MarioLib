//
//  XYAdvFieldDelegate.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/14/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Delegate for XYAdvField
 */
@protocol XYAdvFieldDelegate <NSObject>
@required
/**
 Return the view controller if field is used on ipad without wrapping in XYTableCell
 */
-(UIViewController*)subViewController;

/**
 Render the view based on selected options/values
 */
-(void)renderFieldView;

/**
 Show popover view on ipad
*/
-(void)showPopoverInputView;

/**
 Set whether popover view is used, on ipad without wrapping in XYTableCell, set to YES
 */
-(void)setPopOverOptionView:(BOOL) b;

/**
 Whether popover view is used
 */
-(BOOL)isPopOverOptionView;

/**
 Call back method if value entered
 */
-(void)addTarget:(id)target action:(SEL) selector;
@end
