//
//  XYAdvField.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectOptionField.h"

@implementation XYSelectOptionField
{
    UIViewController* vc;
    XYSelectOptionViewController* pvc;
    UIPopoverController* pc;
}
@synthesize textViewDelegate = _textViewDelegate;
@synthesize popOverTextViewDelegate = _popOvertextViewDelegate;
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;
@synthesize fieldSelectionOption = _fieldSelectionOption;
@synthesize advFieldType = _advFieldType;
@synthesize lowValuePlaceholder = _lowValuePlaceholder;
@synthesize lowValueKeyboardType = _lowValueKeyboardType;
//@synthesize lowValueDisplayDateFormat = _lowValueDisplayDateFormat;
@synthesize highValuePlaceholder = _highValuePlaceholder;
@synthesize highValueKeyboardType = _highValueKeyboardType;
//@synthesize highValueDisplayDateFormat = _highValueDisplayDateFormat;
@synthesize datePickMode = _datePickMode;
@synthesize signDictionary = _signDictionary;
@synthesize operatorDictionary = _operatorDictionary;
@synthesize dateValueFormat = _dateValueFormat;
@synthesize dateFrom = _dateFrom;
@synthesize dateTo = _dateTo;

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        _minHeight = view.textView.frame.size.height;
        view.label.text = label;
        _view = view;
        _name = name;
        [self setPopOverOptionView:NO];
        _fieldSelectionOption = [XYFieldSelectOption new];
        _fieldSelectionOption.property = name;
    }
    return self;
}

-(XYInputTextViewView*)view{
    return (XYInputTextViewView*)_view;
}


-(XYSelectOption*)selectOptionByString:(NSString*)value{
    NSArray* values = [value componentsSeparatedByString:@"|"];
    NSString* sign = @"";
    NSString* signText = @"";
    NSString* option = @"";
    NSString* optionText = @"";
    NSString* lowValue = @"";
    NSString* highValue = @"";
    if (values.count >= 3) {
        sign = [values objectAtIndex:0];
        signText = [_signDictionary objectForKey:sign];
        option = [values objectAtIndex:1];
        optionText = [_operatorDictionary objectForKey:option];
        lowValue = [values objectAtIndex:2];
    }
    if (values.count == 4) {
        highValue = [values objectAtIndex:3];
    }
    XYSelectOption* so = [[XYSelectOption alloc] initWithSign:sign option:option lowValue:lowValue highValue:highValue];
    return so;
}

-(NSString*)stringValueOfSelectOption:(XYSelectOption*) so{
    NSString* result;
    NSString* lowValue;
    NSString* highValue;
    if (_advFieldType == XYAdvFieldTypeDate) {
        lowValue = [XYUtility dateToString:_dateValueFormat date:self.dateFrom];
        highValue = [XYUtility dateToString:_dateValueFormat date:self.dateTo];
    } else {
        lowValue = so.lowValue;
        highValue = so.highValue;
    }
    
    lowValue = lowValue == nil ? @"" : lowValue;
    highValue = highValue == nil ? @"" : highValue;
    
    if (so.highValue != nil && ![so.highValue isEqualToString:@""]) {
        result = [NSString stringWithFormat:@"%@|%@|%@|%@",so.sign,so.option,lowValue,highValue];
    } else {
        result = [NSString stringWithFormat:@"%@|%@|%@",so.sign, so.option,lowValue];
    }
    return result;
}

-(NSString*)stringTextValueOfSelectOption:(XYSelectOption*) so{
    NSString* result;
    NSString* lowValue;
    NSString* highValue;
    
    lowValue = so.lowValue == nil ? @"" : so.lowValue;
    highValue = so.highValue == nil ? @"" : so.highValue;
    
    NSString* signText = [_signDictionary objectForKey:so.sign];
    NSString* optionText = [_operatorDictionary objectForKey:so.option];
    signText = signText == nil ? @"" : signText;
    optionText = optionText == nil ? @"" : optionText;
    
    if (so.highValue != nil && ![so.highValue isEqualToString:@""]) {
        result = [NSString stringWithFormat:@"%@ %@ %@ %@",signText,optionText,lowValue,highValue];
    } else {
        result = [NSString stringWithFormat:@"%@ %@ %@",signText,optionText,lowValue];
    }
    return result;
}

-(void)setValue:(NSString *)value{
    _value = value;    
    XYSelectOption* so = [self selectOptionByString:_value];
    _fieldSelectionOption = [[XYFieldSelectOption alloc] initWithProperty:_name andSelectOption:so];
    [self renderFieldView];
}

-(NSString*)value{
//    if (_fieldSelectionOption.selectOptions.count == 0) {
//        XYSelectOption* so = [[XYSelectOption alloc] initWithSign:@"I" option:@"EQ" lowValue:((XYInputTextViewView*)_view).textView.text highValue:nil];
//        _fieldSelectionOption = [[XYFieldSelectOption alloc] initWithProperty:_name andSelectOption:so];
//        [self renderFieldView];
//        return [self stringValueOfSelectOption:so];
//    } else {
//        return _value;
//    }
    return _value;
    
}

-(void)clearValue{
    _fieldSelectionOption.selectOptions = [NSSet new];
    [self renderFieldView];
}

-(void)resignFirstResponder{
    [((XYInputTextViewView*)_view).textView resignFirstResponder];
}

-(void)renderFieldView{
    NSString* displayText = @"";
    NSString* displayValue = @"";
    NSInteger countOfSelectedOption = _fieldSelectionOption.selectOptions.count;
    NSInteger* currentRow = 0;
    for (XYSelectOption* so in _fieldSelectionOption.selectOptions) {
        if (currentRow > 0) {
            displayText = [NSString stringWithFormat:@"%@\n%@",displayText,[self stringTextValueOfSelectOption:so]];
            displayValue = [NSString stringWithFormat:@"%@#%@",displayValue,[self stringValueOfSelectOption:so]];
        } else {
            displayText = [self stringTextValueOfSelectOption:so];
            displayValue = [self stringValueOfSelectOption:so];
        }
        currentRow++;
    }
    
    _value = displayValue;
    ((XYInputTextViewView*)_view).textView.text = displayText;
    
    // Adjust textview to display all item
    CGRect newFrame = self.view.frame;
    CGSize contentSize = ((XYInputTextViewView*)self.view).textView.contentSize;
    
    if (countOfSelectedOption > 0 && contentSize.height > newFrame.size.height) {
        newFrame.size.height = contentSize.height + _view.viewAtBottom.bounds.size.height;
    } else {
        newFrame.size.height = _minHeight;
    }
    [((XYInputTextViewView*)self.view) setFrame:newFrame];
}


-(UIViewController*)advFieldViewController{
    return [[XYSelectOptionViewController alloc] initWithStyle:UITableViewStyleGrouped];
}
@end
