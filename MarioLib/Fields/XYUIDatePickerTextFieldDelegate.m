//
//  XYUIDatePickerTextFieldDelegate.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUIDatePickerTextFieldDelegate.h"

@implementation XYUIDatePickerTextFieldDelegate
{
    UIViewController* vc;
    XYBasePopOverViewController* pvc;
    UIPopoverController* pc;
}
@synthesize datePicker;
@synthesize datePickerField;

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (datePicker != nil && ( textField.text == nil || [textField.text isEqualToString:@""])) {
        NSDateFormatter* nsdf = [[NSDateFormatter alloc] init];
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        [nsdf setDateFormat:@"dd.MM.yyyy"];
        NSString* now = [nsdf stringFromDate:datePicker.date];
        textField.text = now;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [datePickerField showPopoverInputView];
        return NO;
    }
    return YES;
}
@end
