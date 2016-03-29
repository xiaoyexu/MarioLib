//
//  XYDynaSearchField.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAdvSearchField.h"

@implementation XYAdvSearchField
{
    UIViewController* vc;
    XYDynaSearchFieldViewController* pvc;
    UIPopoverController* pc;
}

@synthesize textViewDelegate = _textViewDelegate;
@synthesize popOverTextViewDelegate = _popOvertextViewDelegate;
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;
@synthesize delegate = _delegate;
@synthesize selectedLabelValue = _selectedLabelValue;
@synthesize maxLine = _maxLine;
@synthesize placeholder = _placeholder;
@synthesize enableSearchTextHistory = _enableSearchTextHistory;

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        _minHeight = view.textView.frame.size.height;
        view.label.text = label;
        _view = view;
        _name = name;
        _enableSearchTextHistory = YES;
        [self setPopOverOptionView:NO];
    }
    return self;
}

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r delegate:(id<XYAdvSearchFieldDelegate>) delegate{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        _minHeight = view.textView.frame.size.height;
        view.label.text = label;
        _view = view;
        _name = name;
        _enableSearchTextHistory = YES;
        _delegate = delegate;
        [self setPopOverOptionView:NO];
    }
    return self;
}

-(XYInputTextViewView*)view{
    return (XYInputTextViewView*)_view;
}

-(void)setValue:(NSString *)value{
    _value = value;
}

-(NSString*)value{
    return _value;
}

-(void)clearValue{
    _selectedLabelValue = [XYLabelValue new];
    [self renderFieldView];
}

-(void)resignFirstResponder{
    [((XYInputTextViewView*)_view).textView resignFirstResponder];
}

-(void)renderFieldView{
    NSString* displayText = @"";
    NSString* displayValue = @"";
    
    displayText = self.selectedLabelValue.label;
    displayValue = self.selectedLabelValue.value;
    
    _value = displayValue;
    ((XYInputTextViewView*)_view).textView.text = displayText;
    
    // Adjust textview to display all item
    CGRect newFrame = self.view.frame;
    CGSize contentSize = ((XYInputTextViewView*)self.view).textView.contentSize;
    
    if (self.selectedLabelValue != nil && contentSize.height > newFrame.size.height) {
        newFrame.size.height = contentSize.height + _view.viewAtBottom.bounds.size.height;
    } else {
        newFrame.size.height = _minHeight;
    }
    [((XYInputTextViewView*)self.view) setFrame:newFrame];
}

-(UIViewController*)advFieldViewController{
    XYAdvSearchFieldViewController* dsfvc = [XYAdvSearchFieldViewController new];
    dsfvc.navigationBarTitle = @"Please Search...";
    dsfvc.searchBarPlaceholder = _placeholder;
    dsfvc.advField = self;
    return dsfvc;
}

-(void)setSelectedLabelValue:(XYLabelValue *)selectedLabelValue{
    _selectedLabelValue = selectedLabelValue;
    [self renderFieldView];
}

@end
