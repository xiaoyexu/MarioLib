//
//  XYInputTextField.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYField.h"
#import "XYInputTextFieldView.h"
#import "XYUITextFieldDelegate.h"

/**
 XYInputTextField represents an input field
 */
@interface XYInputTextField :XYField

/**
 Field view
 */
@property (nonatomic,readonly) XYInputTextFieldView* view;

/**
 Maximum length of input text
 */
@property (nonatomic) NSUInteger maxLength;

/**
 Default text when text field focused
 */
@property (nonatomic, strong) NSString* defaultValueOnEnter;

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
  Monitor UIKeyboardDidShowNotification in order to redraw the keyboard to add "DONE" button
 */
-(void)keyboardDidShow:(NSNotification*)notif;

@end
