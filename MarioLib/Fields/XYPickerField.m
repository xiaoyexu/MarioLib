//
//  XYPickerField.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYPickerField.h"

@implementation XYPickerField
{
    UIPickerView* pickView;
    UIView* pickInputView;
    UIToolbar* bar;
    // For ipad use popover view
    UIViewController* vc;
    XYBasePopOverViewController* pvc;
    UIPopoverController* pc;
}
@synthesize pickList = _pickList;
@synthesize pickDict = _pickDict;
@synthesize selectedLabelValue = _selectedLabelValue;
//@synthesize enableToolBar = _enableToolBar;

-(id)initWithName:(NSString *)name{
    if (self = [super init]) {
        XYInputTextFieldView* view = [XYInputTextFieldView new];
        view.labelContainerViewEnabled = NO;
        //view.textView.editable = NO;
        _view = view;
        _name = name;
        [self renderField];
    }
    return self;
}


-(id)initWithName:(NSString *)name frame:(CGRect)f ratio:(float)r{
    if (self = [super init]) {
        XYInputTextFieldView* view = [[XYInputTextFieldView alloc] initWithFrame:f andRatio:r];
        //view.textView.editable = NO;
        _view = view;
        _name = name;
        [self renderField];
    }
    return self;
}



-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super init]) {
        XYInputTextFieldView* view = [[XYInputTextFieldView alloc] initWithFrame:f andRatio:r];
        view.label.text = label;
        //view.textView.editable = NO;
        _view = view;
        _name = name;
        [self renderField];
    }
    return self;
}

-(XYInputTextFieldView*)view{
    return (XYInputTextFieldView*)_view;
}

-(void)renderField{
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    pickView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.showsSelectionIndicator = YES;
    ((XYInputTextFieldView*)_view).textField.delegate = self;
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        // Iphone view
        float width = [UIScreen mainScreen].bounds.size.width;
        float height = 260;
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            width = [UIScreen mainScreen].bounds.size.height;
            height = 200;
        }
        pickInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 45)];
        ((XYInputTextFieldView*)_view).textField.inputView = pickInputView;
    } else {
        pickInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        // Set input as blank view
        ((XYInputTextFieldView*)_view).textField.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    // Set input view
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        pickInputView.backgroundColor = [UIColor clearColor];
    } else {
        pickInputView.backgroundColor = [UIColor whiteColor];
    }
    
    UIBarButtonItem* clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearValue)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    bar.barStyle = (UIBarStyle)[XYSkinManager instance].xyPickerFieldBarStyle;
    bar.items = [NSArray arrayWithObjects:clear, space, done, nil];
    [pickInputView addSubview:bar];
    [pickInputView addSubview:pickView];
}

-(void)setValue:(NSString *)value{
    ((XYInputTextFieldView*)_view).textField.text = value;
}

-(NSString*)value{
    return ((XYInputTextFieldView*)_view).textField.text;
}

-(void)clearValue{
    self.value = @"";
    self.selectedLabelValue = [XYLabelValue new];
}

-(void)resignFirstResponder{
    [((XYInputTextFieldView*)_view).textField resignFirstResponder];
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
            pc.popoverContentSize = CGSizeMake(pickInputView.bounds.size.width, pickInputView.bounds.size.height);
          
            [pvc.view addSubview:pickInputView];
            [pvc.view bringSubviewToFront:pickInputView];
            
            //Find if super view is UITableViewCell
            UIView* superView = _view;
            BOOL tableViewCellFound = NO;
            while ((superView = superView.superview)) {
                if ([superView isKindOfClass:[UITableViewCell class]]) {
                    tableViewCellFound = YES;
                    break;
                }
            }
            
            CGRect viewFrame;
            
            if (tableViewCellFound) {
                viewFrame = superView.bounds;
            } else {
                viewFrame = _view.bounds;
            }
            
            float x = floor( viewFrame.size.width / 2 );
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    XYLabelValue* lv = [_pickList objectAtIndex:row];
    return lv.label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    XYLabelValue* lv = [_pickList objectAtIndex:row];
    self.value = lv.label;
    self.selectedLabelValue = lv;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self showPopoverInputView];
        return NO;
    }
    return YES;
}

-(void)done{
    [((XYInputTextFieldView*)_view).textField resignFirstResponder];
    if (pc.isPopoverVisible) {
        [pc dismissPopoverAnimated:YES];
    }
}

-(void)setPickDict:(NSDictionary *)pickDict{
    _pickDict = pickDict;
    NSMutableArray* list = [NSMutableArray new];
    for (id key in pickDict.keyEnumerator) {
        XYLabelValue* lv = [XYLabelValue labelWith:[pickDict objectForKey:key] value:key];
        [list addObject:lv];
    }
    _pickList = list;
}

-(NSDictionary*)pickDict{
    return _pickDict;
}

//-(void)setEnableToolBar:(BOOL)enableToolBar{
//    _enableToolBar = enableToolBar;
//    if (_enableToolBar) {
//        if (bar.superview != pickInputView) {
//            [pickInputView addSubview:bar];
//            CGRect f = pickInputView.frame;
//            f.size.height += bar.bounds.size.height;
//            pickInputView.frame = f;
//        }
//    } else {
//        [bar removeFromSuperview];
//        CGRect f = pickInputView.frame;
//        f.size.height -= bar.bounds.size.height;
//        pickInputView.frame = f;
//    }
//}
//
//-(BOOL)enableToolBar{
//    return _enableToolBar;
//}
@end
