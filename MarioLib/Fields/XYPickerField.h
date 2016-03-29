//
//  XYPickerField.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYField.h"
#import "XYInputTextFieldView.h"
#import "XYLabelValue.h"
#import "XYBasePopOverViewController.h"
#import "XYKeyboardListener.h"

/**
 This class represents a picker field, user can enter value by select value in UIPickerView
 */
@interface XYPickerField :XYField <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

/**
 Field view
 */
@property (nonatomic,readonly) XYInputTextFieldView* view;

/**
 Either use pickList or pickDic
 Array list contains XYLabelValue objects
 */
@property(nonatomic, strong) NSArray* pickList;

/**
 Either use pickList or pickDic
 Dictionary as pick list
 */
@property(nonatomic, strong) NSDictionary* pickDict;

/**
 XYLabelValue object for field selected
 */
@property(nonatomic, strong) XYLabelValue* selectedLabelValue;

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

@end
