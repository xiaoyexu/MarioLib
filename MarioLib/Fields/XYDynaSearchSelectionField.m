//
//  XYDynaSearchField.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYDynaSearchSelectionField.h"

@implementation XYDynaSearchSelectionField
{
    UIViewController* vc;
    XYDynaSearchFieldViewController* pvc;
    UIPopoverController* pc;
}

@synthesize textViewDelegate = _textViewDelegate;
@synthesize popOverTextViewDelegate = _popOvertextViewDelegate;
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;
@synthesize selectedLabelValue = _selectedLabelValue;
@synthesize maxLine = _maxLine;
@synthesize placeholder = _placeholder;
@synthesize selection = _selection;

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

//-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r delegate:(id<XYDynaSearchFieldDelegate>) delegate{
//    if (self = [super init]) {
//        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
//        _minHeight = view.textView.frame.size.height;
//        view.label.text = label;
//        _view = view;
//        _name = name;
//        [self setPopOverOptionView:NO];
//    }
//    return self;
//}

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
    XYDynaSearchSelectionFieldViewController* dssfvc = [XYDynaSearchSelectionFieldViewController new];
    dssfvc.searchBarPlaceholder = _placeholder;
    dssfvc.advField = self;
    return dssfvc;
}

-(void)setSelectedLabelValue:(XYLabelValue *)selectedLabelValue{
    _selectedLabelValue = selectedLabelValue;
    [self renderFieldView];
}

-(void)setSelectionByArray:(NSArray*)selectionArray{
    NSMutableArray* innerOptions = [NSMutableArray new];
    XYLabelValue* labelValue;
    NSString* key;
    NSString* value;
    for (id obj in selectionArray) {
        if ([obj isKindOfClass:[XYLabelValue class]]) {
            [innerOptions addObject:obj];
            continue;
        } else {
            value = [obj description];
            key = [obj description];
        }
        labelValue = [XYLabelValue labelWith:value value:key];
        [innerOptions addObject:labelValue];
    }
    _selection = innerOptions;
}

-(void)setSelectionByDictionary:(NSDictionary*)selectionDictionary{
    // wrap option to XYSelectionItemField
    NSMutableArray* innerOptions = [NSMutableArray new];
    
    [selectionDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString* k = key;
        NSString* v = obj;
        XYLabelValue* labelValue = [XYLabelValue labelWith:v value:k];
        [innerOptions addObject:labelValue];
    }];
    
    _selection = innerOptions;
}

@end
