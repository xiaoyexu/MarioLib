//
//  XYUITextFieldDelegate.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUITextFieldDelegate.h"

@implementation XYUITextFieldDelegate

@synthesize maxLength;
@synthesize textField = _textField;
@synthesize defaultValueOnEnter = _defaultValueOnEnter;

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (maxLength > 0 && range.location >= maxLength) {
        return NO;
    } else {
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length == 0 &&  _defaultValueOnEnter != nil && ![_defaultValueOnEnter isEqualToString:@""]) {
        textField.text = _defaultValueOnEnter;
    }
    // For UIKeyboardTypeNumberPad, add observer to UIKeyboardDidShowNotification to add "Done" button
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        [[NSNotificationCenter defaultCenter] addObserver:_textField selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }     
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    // For UIKeyboardTypeNumberPad, remove observer so that the UIKeyboardDidShowNotification won't be called again for other keyboard type
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        [[NSNotificationCenter defaultCenter] removeObserver:_textField name:UIKeyboardDidShowNotification object:nil];
    }
    
}
@end
