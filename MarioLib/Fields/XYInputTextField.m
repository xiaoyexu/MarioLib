//
//  XYInputTextField.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYInputTextField.h"

@implementation XYInputTextField
{
    XYUITextFieldDelegate* textFieldDelegate;
    UIButton *doneButton;
}
@synthesize maxLength = _maxLength;
@synthesize defaultValueOnEnter = _defaultValueOnEnter;

-(id)init{
    if (self = [super init]) {
        XYInputTextFieldView* view = [XYInputTextFieldView new];
        textFieldDelegate = [XYUITextFieldDelegate new];
        textFieldDelegate.textField = self;
        // Set a blank inputAccessoryView so that UIKeyboardDidShowNotification will be triggered
        view.textField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
        view.textField.delegate = textFieldDelegate;
        _view = view;
    }
    return self;
}

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super initWithName:name frame:f ratio:r]) {
        UIEdgeInsets inset = UIEdgeInsetsMake(5, 5, 5, 5);
        XYInputTextFieldView* view = [[XYInputTextFieldView alloc] initWithFrame:f contentInset:inset andRatio:r];
        view.label.text = label;
        textFieldDelegate = [XYUITextFieldDelegate new];
        textFieldDelegate.textField = self;
        // Set a blank inputAccessoryView so that UIKeyboardDidShowNotification will be triggered
        view.textField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
        view.textField.delegate = textFieldDelegate;
        _view = view;
    }
    return self;
}

-(XYInputTextFieldView*)view{
    return (XYInputTextFieldView*)_view;
}

-(void)setValue:(NSString *)value{
    ((XYInputTextFieldView*)_view).textField.text = value;
}

-(NSString*)value{
    return ((XYInputTextFieldView*)_view).textField.text == nil ? @"" : ((XYInputTextFieldView*)_view).textField.text;
}

-(void)setMaxLength:(NSUInteger)maxLength{
    textFieldDelegate.maxLength = maxLength;
}

-(NSUInteger)maxLength{
    return textFieldDelegate.maxLength;
}

-(void)setDefaultValueOnEnter:(NSString *)defaultValueOnEnter{
    textFieldDelegate.defaultValueOnEnter = defaultValueOnEnter;
}

-(NSString*)defaultValueOnEnter{
    return textFieldDelegate.defaultValueOnEnter;
}

-(void)clearValue{
    self.value = @"";
}

-(void)resignFirstResponder{
    [((XYInputTextFieldView*)_view).textField resignFirstResponder];
}

-(void)setEditable:(BOOL)editable{
    _editable = editable;
    ((XYInputTextFieldView*)_view).textField.enabled = editable ;
}

-(BOOL)editable{
    return ((XYInputTextFieldView*)_view).textField.enabled ;
}

/*
  Found keyboard view
  View structure as below
  UIWindow
    UILayoutContainerView
      UINavigationTransitionView
        UIViewControllerWrapperView
      UINavigationBar
        _UINavigationBarBackground
        UINavigationButton
          SAPTitleLabel
 
  When receive UIKeyboardWillShowNotification:
 
  UIWindow
    UILayoutContainerView
      UINavigationTransitionView
        UIViewControllerWrapperView
      UINavigationBar
        _UINavigationBarBackground
        UINavigationButton
          SAPTitleLabel
  UITextEffectsWindow
 
  When receive UIKeyboardWillShowNotification:
  UIWindow
    UILayoutContainerView
      UINavigationTransitionView
        UIViewControllerWrapperView
      UINavigationBar
        _UINavigationBarBackground
        UINavigationButton
          SAPTitleLabel
  UITextEffectsWindow
    UIPeripheralHostView
      UIKeyboardAutomatic
        UIKeyboardLayoutStar
          UIKBKeyplaneView       12 subviews for numberpad 4 for default type
            UIKBKeyView
 */

-(UIView*)getKeyboardView{
    if ([[UIApplication sharedApplication] windows].count < 2) {
        return nil;
    }
    
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard = nil;
    
    //NSLog(@"tempwindow subview count:%d",[tempWindow.subviews count]);
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard found, add the button
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES){
//                UIView* keyboardAutomatic = [keyboard.subviews objectAtIndex:0];
//                UIView* keyboardLayoutStar = [keyboardAutomatic.subviews objectAtIndex:0];
//                UIView* KBKeyplaneView = [keyboardLayoutStar.subviews objectAtIndex:0];
//                UIView* KBKeyView = [KBKeyplaneView.subviews objectAtIndex:0];
//                UIView* KBKeyView2 = [KBKeyView.subviews objectAtIndex:0];
                return keyboard;
            }
        } else {
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES){
                return keyboard;
            }
            
        }
    }
    return nil;
}

/*
  Add "Done" button for number pad
 */
-(void)addButtonOnKeyboardView:(UIView*)keyboardView{
    if (keyboardView == nil) {
        return;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (self.view.textField.keyboardType == UIKeyboardTypeNumberPad) {
            // create custom button
            if (doneButton == nil) {
                doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
            } else {
                [doneButton removeFromSuperview];
            }
            
            
            if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
                doneButton.frame = CGRectMake(0, 123, 158, 43);
            } else {
                doneButton.frame = CGRectMake(0, 163, 106, 53);
            }
            
            doneButton.backgroundColor = [UIColor clearColor];
            doneButton.adjustsImageWhenHighlighted = NO;
            
            //[doneButton setBackgroundImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
            //[doneButton setBackgroundImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
            
            [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
            doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
            
            doneButton.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            doneButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [doneButton addTarget:self action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
            
            [keyboardView addSubview:doneButton];
        }
        
    }
}

-(void)keyboardDidShow:(NSNotification *)notif{
    [self addButtonOnKeyboardView:[self getKeyboardView]];
}

@end