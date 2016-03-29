//
//  XYDatePickerField.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYField.h"
#import "XYInputTextFieldView.h"
#import "XYUIDatePickerTextFieldDelegate.h"
#import "XYInputTextViewView.h"
#import "XYBasePopOverViewController.h"
#import "XYUtility.h"
#import "XYKeyboardListener.h"

/**
 This class represents a date picker field, user can enter value by select value in UIDatePicker
 */
@interface XYDatePickerField :XYField

/**
 datePickerMode value
 */
@property (nonatomic) UIDatePickerMode datePickerMode;

/**
 Date format if different format wanted
 */
@property (nonatomic, strong) NSString* valueDateFormat;

/**
 Initialization method with field name, frame, label, ratio
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r;

/**
 Return XYInputTextFieldView
 */
-(XYInputTextFieldView*)view;

/**
 Show popover view when used on ipad
 */
-(void)showPopoverInputView;

/**
 Set date value. Rule as follows
 For UIDatePickerModeDate, format dd.MM.YYYY, e.g. 31.12.2011
 For UIDatePickerModeTime, format HH:mm:ss, e.g. 23:58:12
 For UIDatePickerModeDateAndTime, format dd.MM.yyyy HH:mm, e.g. 31.12.2013 19:23
 */
-(void)setValue:(NSString *)value;

/**
 Return date value string, if valueDateFormat is provided, format the output
 */
-(NSString*)value;

/**
 Return formatted date value
 */
-(NSString*)formattedDateValue;

/**
 Set date
 @param date Date to set
 */
-(void)setDate:(NSDate*)date;

/**
 @return date
 */
-(NSDate*)date;
@end
