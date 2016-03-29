//
//  XYAdvField.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAdvField.h"

@implementation XYAdvField
{
    UIViewController* vc;
    UIViewController* pvc;
    UIPopoverController* pc;
}
@synthesize textViewDelegate = _textViewDelegate;
@synthesize popOverTextViewDelegate = _popOvertextViewDelegate;
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;
@synthesize selectionCompletedSelector = _selectionCompletedSelector;
@synthesize barButtonItem = _barButtonItem;

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        _minHeight = view.textView.frame.size.height;
        view.label.text = label;
        _view = view;
        _name = name;
        [self setPopOverOptionView:NO];
    }
    return self;
}

-(XYFieldView*)view{
    return (XYFieldView*)_view;
}

-(void)setValue:(NSString *)value{

}

-(NSString*)value{
    return _value;
}

-(void)clearValue{
    [self renderFieldView];
}

-(void)resignFirstResponder{
    [((XYInputTextViewView*)_view).textView resignFirstResponder];
}


// Render field value or frame size
-(void)renderFieldView{
    _value = [self renderDisplayValue];
    ((XYInputTextViewView*)_view).textView.text = [self renderDisplayText];
    
    // Adjust textview to display all item
    CGRect newFrame = self.view.frame;
    CGSize contentSize = ((XYInputTextViewView*)self.view).textView.contentSize;
    
    if (![self fieldIsEmpty] && contentSize.height > newFrame.size.height) {
        newFrame.size.height = contentSize.height + _view.viewAtBottom.bounds.size.height;
    } else {
        newFrame.size.height = _minHeight;
    }
    [((XYInputTextViewView*)self.view) setFrame:newFrame];
}

// Return the view controller when field selected
-(UIViewController*)subViewController{
    UIViewController* viewController;
    UIResponder* responder = self.view;
    while (![(responder = [responder nextResponder]) isKindOfClass:[UIViewController class]] && responder != nil);
    viewController = (UIViewController*)responder;
    
    UIViewController* afvc = [self advFieldViewController];
    
    if ([afvc conformsToProtocol:@protocol(XYAdvFieldViewControllerDelegate)]) {
        [((id<XYAdvFieldViewControllerDelegate>)afvc) setAdvField:self];
        [((id<XYAdvFieldViewControllerDelegate>)afvc) loadAdvFieldValue];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad ){
        CGRect frame;
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.width - 100);
        } else {
            frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 100);
        }
        [afvc.view setFrame:frame];
        
    }
    return afvc;
}

// Method to show popover view controller for iPad
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
        
        // Always created new popover view controller, in case data is refreshed
        pvc = [self subViewController];
        
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:pvc];
        
        if (_barButtonItem != nil) {
            nav.navigationItem.leftBarButtonItem = nil;
        }
        
        pc = [[UIPopoverController alloc] initWithContentViewController:nav];
        if ([pvc isKindOfClass:[XYBaseUITableViewController class]]) {
            ((XYBaseUITableViewController*)pvc).popOverController = pc;
        }
        if ([pvc isKindOfClass:[XYBaseUIViewController class]]) {
            ((XYBaseUIViewController*)pvc).popOverController = pc;
        }

        if (!pc.isPopoverVisible ) {
            [pvc becomeFirstResponder];
            
            if (_barButtonItem != nil) {
                [pc presentPopoverFromBarButtonItem:_barButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            } else {
                CGSize s = CGSizeMake(320, 400);
                pc.popoverContentSize = s;
                
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
                
                float x = floor(viewFrame.size.width / 2 );
                float y = viewFrame.size.height;
                
                float screenWidth;
                float screenHeight;
                if ([[UIDevice currentDevice] orientation] == (UIDeviceOrientationLandscapeLeft | UIDeviceOrientationLandscapeRight)) {
                    screenHeight = [UIScreen mainScreen].bounds.size.width;
                    screenWidth = [UIScreen mainScreen].bounds.size.height;
                } else {
                    screenHeight = [UIScreen mainScreen].bounds.size.height;
                    screenWidth = [UIScreen mainScreen].bounds.size.width;
                }
                CGPoint newP = [_view convertPoint:CGPointMake(x, y) toView:vc.view];
                
                if (newP.y > screenHeight/2  || [XYKeyboardListener instance].visible) {
                    newP.y -= viewFrame.size.height;
                    [pc presentPopoverFromRect:CGRectMake(newP.x,newP.y,1,1) inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                } else {
                    [pc presentPopoverFromRect:CGRectMake(newP.x,newP.y,1,1) inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                }
            }
        } else {
            [pc dismissPopoverAnimated:YES];
        }
        
    }

}

-(void)setPopOverOptionView:(BOOL) b{
    _isPopOverOptionView = b;
    if (b) {
        _popOvertextViewDelegate = [XYUISelectionTextViewDelegate new];
        _popOvertextViewDelegate.field = self;
        ((XYInputTextViewView*)_view).textView.delegate = _popOvertextViewDelegate;
        ((XYInputTextViewView*)_view).textView.editable = YES;
        ((XYInputTextViewView*)_view).textView.userInteractionEnabled = YES;
        ((XYInputTextViewView*)_view).userInteractionEnabled = YES;
    } else {
        _popOvertextViewDelegate = nil;
        ((XYInputTextViewView*)_view).textView.delegate = nil;
        ((XYInputTextViewView*)_view).textView.editable = NO;
        ((XYInputTextViewView*)_view).textView.userInteractionEnabled = NO;
        ((XYInputTextViewView*)_view).userInteractionEnabled = NO;
    }
}

-(BOOL)isPopOverOptionView{
    return _isPopOverOptionView;
}

// Add selector for item selected
-(void)addTarget:(id)target action:(SEL) selector{
    _selectionCompletedSelector = [[XYSelectorObject alloc] initWithSEL:selector target:target];
}

// Whether field is editable
-(void)setEditable:(BOOL)editable{
    _editable = editable;
    ((XYInputTextViewView*)_view).textView.editable = editable ;
    ((XYInputTextViewView*)_view).textView.userInteractionEnabled = editable;
}

// Method to initialize the view controller for field
-(UIViewController*)advFieldViewController{
    return nil;
}

// Method to render display text
-(NSString*)renderDisplayText{
    return @"";
}

// Method to render display value
-(NSString*)renderDisplayValue{
    return @"";
}

// Return whether field is empty
-(BOOL)fieldIsEmpty{
    return YES;
}

@end
