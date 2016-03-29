//
//  XYUITextViewDelegate.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUITextViewDelegate.h"

@implementation XYUITextViewDelegate
@synthesize rollTableCell = _rollTableCell;
//@synthesize maxLength;
//@synthesize maxLine;
@synthesize noLineBreaker;

-(void)textViewDidChange:(UITextView *)textView{
    if (_rollTableCell == nil) {
        return;
    }
    if (_tableView == nil) {
        UIView* v = textView;
        while (![v isKindOfClass:[UITableView class]]) {
            v = v.superview;
            if (v == nil) {
                return;
            }
        }
        _tableView = (UITableView*)v;
    }
    
    float newHeight;
    BOOL scrollToLastLine = NO;
    
    XYBaseView* baseView = _rollTableCell.field.view;

    if (textView.contentSize.height <= _rollTableCell.minHeight) {
        newHeight = _rollTableCell.minHeight;
    } else if (textView.contentSize.height > _rollTableCell.minHeight && textView.contentSize.height <= _rollTableCell.maxHeight) {
        newHeight = textView.contentSize.height;
    } else {
        scrollToLastLine = YES;
        newHeight = _rollTableCell.maxHeight;
    }
    CGRect f;
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, newHeight);
    
    if (scrollToLastLine) {
        textView.contentOffset = CGPointMake(8, textView.contentSize.height - textView.frame.size.height);
    }
    f = _rollTableCell.view.frame;
    f.size.height = newHeight + baseView.contentInset.top + baseView.contentInset.bottom;
    
    // Add additional height to text view of portrait layout
    if ([_rollTableCell.field.view isKindOfClass:[XYInputTextViewView class]]) {
        
        switch (((XYInputTextViewView*)_rollTableCell.field.view).layout) {
            case XYFieldViewLayoutLabelAtTopTextAtBottom:{
                f.size.height += 34;
            }
                break;
                
            default:
                break;
        }
    }
    
    
    [_rollTableCell.view setFrame:f];
    [_tableView beginUpdates];
    _rollTableCell.height = f.size.height;
    [_tableView endUpdates];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (noLineBreaker) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    if (maxLine != 0) {
//        int numLines = textView.contentSize.height / textView.font.lineHeight;
//        if ([text isEqualToString:@"\n"]) {
//            [textView resignFirstResponder];
//            return NO;
//        }
//        if (numLines > maxLine) {
//            return NO;
//        } else {
//            return YES;
//        }
//        
//    }
//    return YES;
//}

@end
