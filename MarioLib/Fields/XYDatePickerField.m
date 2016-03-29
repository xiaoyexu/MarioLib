//
//  XYDatePickerField.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYDatePickerField.h"

@implementation XYDatePickerField
{
    XYUIDatePickerTextFieldDelegate* datePickerTextFieldDelegate;
    UIView* datePickerInputView;
    UIDatePicker* datePicker;
    // For ipad use popover view
    UIViewController* vc;
    XYBasePopOverViewController* pvc;
    UIPopoverController* pc;
}
@synthesize valueDateFormat = _valueDateFormat;

-(id)init{
    if (self = [super init]) {
        XYInputTextFieldView* view = [XYInputTextFieldView new];
        [self renderField];
        _view = view;
    }
    return self;
}

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super initWithName:name frame:f ratio:r]) {
        XYInputTextFieldView* view = [[XYInputTextFieldView alloc] initWithFrame:f andRatio:r];
        view.label.text = label;
        _view = view;
        [self renderField];
    }
    return self;
}

-(void)renderField{
    datePickerTextFieldDelegate = [XYUIDatePickerTextFieldDelegate new];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateDateValue) forControlEvents:UIControlEventValueChanged];
    datePickerTextFieldDelegate.datePicker = datePicker;
    datePickerTextFieldDelegate.datePickerField = self;
    ((XYInputTextFieldView*)_view).textField.delegate = datePickerTextFieldDelegate;
    ((XYInputTextFieldView*)_view).textField.placeholder = @"DD.MM.YYYY";
    UIToolbar* bar;
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        // Iphone view
        float width = [UIScreen mainScreen].bounds.size.width;
        float height = 260;
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            width = [UIScreen mainScreen].bounds.size.height;
            height = 200;
        } 
        datePickerInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 45)];
         ((XYInputTextFieldView*)_view).textField.inputView = datePickerInputView;
    } else {
        datePickerInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        // Set input as blank view
        ((XYInputTextFieldView*)_view).textField.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
        
    // Set input view
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        datePickerInputView.backgroundColor = [UIColor clearColor];
    } else {
        datePickerInputView.backgroundColor = [UIColor whiteColor];
    }
    UIBarButtonItem* clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearValue)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    bar.barStyle = (UIBarStyle)[XYSkinManager instance].xyPickerFieldBarStyle;
    bar.items = [NSArray arrayWithObjects:clear, space, done, nil];
    [datePickerInputView addSubview:bar];
    [datePickerInputView addSubview:datePicker];
}

-(XYInputTextViewView*)view{
    return (XYInputTextViewView*)_view;
}

-(void)updateDateValue{
    NSDateFormatter* nsdf = [[NSDateFormatter alloc] init];
    NSString* now;
    if (datePicker.datePickerMode == UIDatePickerModeDate) {
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        [nsdf setDateFormat:@"dd.MM.yyyy"];
        now = [nsdf stringFromDate:datePicker.date];
    }
    if (datePicker.datePickerMode == UIDatePickerModeTime) {
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        [nsdf setDateFormat:@"HH:mm:ss"];
        now = [nsdf stringFromDate:datePicker.date];
    }
    if (datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        [nsdf setDateFormat:@"dd.MM.yyyy HH:mm"];
        now = [nsdf stringFromDate:datePicker.date];
    }
    ((XYInputTextFieldView*)_view).textField.text = now;
}

-(void)clearValue{
    ((XYInputTextFieldView*)_view).textField.text = @"";
    datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    [((XYInputTextFieldView*)_view).textField resignFirstResponder];
}

-(void)done{
    [((XYInputTextFieldView*)_view).textField resignFirstResponder];
    if (pc.isPopoverVisible) {
        [pc dismissPopoverAnimated:YES];
    }
}

-(void)resignFirstResponder{
    [((XYInputTextFieldView*)_view).textField resignFirstResponder];
}

-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
    datePicker.datePickerMode = datePickerMode;
    if (datePicker.datePickerMode == UIDatePickerModeDate) {
        ((XYInputTextFieldView*)_view).textField.placeholder = @"DD.MM.YYYY";
    }
    if (datePicker.datePickerMode == UIDatePickerModeTime) {
        ((XYInputTextFieldView*)_view).textField.placeholder = @"HH:MM:SS";
    }
    if (datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        ((XYInputTextFieldView*)_view).textField.placeholder = @"DD.MM.YYYY HH:MM";
    }
}

-(UIDatePickerMode)datePickerMode{
    return datePicker.datePickerMode;
}

-(void)setValue:(NSString *)value{
    if (value == nil || [value isEqualToString:@""]) {
        ((XYInputTextFieldView*)_view).textField.text = value;
        return;
    }
    
    if (datePicker.datePickerMode == UIDatePickerModeDate) {
        datePicker.date = [XYUtility stringToDate:@"dd.MM.yyyy" dateString:value];
    }
    if (datePicker.datePickerMode == UIDatePickerModeTime) {
        datePicker.date = [XYUtility stringToDate:@"HH:mm:ss" dateString:value];
    }
    if (datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        datePicker.date = [XYUtility stringToDate:@"dd.MM.yyyy HH:mm" dateString:value];
    }
    ((XYInputTextFieldView*)_view).textField.text = value;
}

-(NSString*)value{
    return ((XYInputTextFieldView*)_view).textField.text == nil ? @"" : ((XYInputTextFieldView*)_view).textField.text;
}

-(NSString*)formattedDateValue{
    if (_valueDateFormat != nil && ![_valueDateFormat isEqualToString:@""]) {
        return [XYUtility dateToString:_valueDateFormat date:datePicker.date];
    } else {
        return self.value;
    }
}

-(void)setDate:(NSDate *)date{
    if (date == nil) {
        datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    } else {
        datePicker.date = date;
    }
    [self updateDateValue];
}

-(NSDate*)date{
    return datePicker.date;
}

-(void)showPopoverInputView{
    // For Ipad, use popover view
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Find view controller
        if (vc == nil) {
            UIResponder* responder = _view;
            while ((responder = [responder nextResponder])) {
                if ([responder isKindOfClass:[UIViewController class]]) {
                    vc =(UIViewController*) responder;
                    break;
                }
            }
        }
        if (pvc == nil) {
            pvc = [[XYBasePopOverViewController alloc] init];
            pc = [[UIPopoverController alloc] initWithContentViewController:pvc];
        }
        if (!pc.isPopoverVisible ) {
            //[pc becomeFirstResponder];
            [pvc becomeFirstResponder];
            pc.popoverContentSize = CGSizeMake(datePickerInputView.bounds.size.width, datePickerInputView.bounds.size.height);
            [pvc.view addSubview:datePickerInputView];
            [pvc.view bringSubviewToFront:datePickerInputView];
            
            //Find if super view is UITableViewCell
            UIView* superView = _view;
            BOOL tableViewCellFound = NO;
            while ((superView = superView.superview)) {
                if ([superView isKindOfClass:[UITableViewCell class]]) {
                    tableViewCellFound = YES;
                    break;
                }
            }
            
            CGRect viewFrame = CGRectZero;
            
            if (tableViewCellFound) {
                viewFrame = superView.bounds;
            } else {
                viewFrame = _view.bounds;
            }

            
            float x = floor(viewFrame.size.width / 2 );
            float y = viewFrame.size.height;
            
            float screenWidth;
            float screenHeight;
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||  [[UIDevice currentDevice] orientation] ==UIDeviceOrientationLandscapeRight) {
                screenHeight = [UIScreen mainScreen].bounds.size.width;
                screenWidth = [UIScreen mainScreen].bounds.size.height;
            } else {
                screenHeight = [UIScreen mainScreen].bounds.size.height;
                screenWidth = [UIScreen mainScreen].bounds.size.width;
            }
            
            CGPoint newP = [_view convertPoint:CGPointMake(x, y) toView:vc.view];
            
            if (newP.y > screenHeight/2 || [XYKeyboardListener instance].visible) {
                newP.y -= viewFrame.size.height;
                [pc presentPopoverFromRect:CGRectMake(newP.x,newP.y,1,1) inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            } else {
                [pc presentPopoverFromRect:CGRectMake(newP.x,newP.y,1,1) inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }

        } else {
            [pc dismissPopoverAnimated:YES];
        }
        
    }
}

@end
