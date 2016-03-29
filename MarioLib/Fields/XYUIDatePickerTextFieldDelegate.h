//
//  XYUIDatePickerTextFieldDelegate.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYDatePickerField.h"
#import "XYBasePopOverViewController.h"

@class XYDatePickerField;

/**
 An implementation class for UITextFieldDelegate
 */
@interface XYUIDatePickerTextFieldDelegate : NSObject <UITextFieldDelegate>

/**
 An internal UIDatePick object
 */
@property (nonatomic, strong) UIDatePicker* datePicker;

/**
 Store XYDatePickerField as reference
 */
@property (nonatomic, strong) XYDatePickerField* datePickerField;
@end
