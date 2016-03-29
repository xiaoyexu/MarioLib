//
//  XYUISelectionTextViewDelegate.m
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUISelectionTextViewDelegate.h"

@implementation XYUISelectionTextViewDelegate
@synthesize field = _field;

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ([_field respondsToSelector:@selector(showPopoverInputView)]) {
            [_field performSelector:@selector(showPopoverInputView)];
            return NO;
        }
    }
    return YES;
}
@end
