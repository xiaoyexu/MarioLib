//
//  XYInputTextViewField.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYInputTextViewField.h"

@implementation XYInputTextViewField
@synthesize textViewDelegate = _textViewDelegate;

-(id)initWithName:(NSString *)name frame:(CGRect)f ratio:(float)r{
    if (self = [super initWithName:name frame:f ratio:r]) {
        UIEdgeInsets inset = UIEdgeInsetsMake(5, 5, 5, 5);
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f contentInset:inset andRatio:r];
        view.label.text = @"";
        if (_textViewDelegate == nil) {
            _textViewDelegate = [XYUITextViewDelegate new];
        }
        view.textView.delegate = _textViewDelegate;
        //view.textView.backgroundColor = [UIColor grayColor];
        //view.textView.userInteractionEnabled = NO;
        _view = view;
        _name = name;
        
    }
    return self;
}


-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super initWithName:name frame:f ratio:r]) {
        UIEdgeInsets inset = UIEdgeInsetsMake(5, 5, 5, 5);
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f contentInset:inset andRatio:r];
        view.label.text = label;
        if (_textViewDelegate == nil) {
            _textViewDelegate = [XYUITextViewDelegate new];
        }
        view.textView.delegate = _textViewDelegate;
        //view.textView.backgroundColor = [UIColor grayColor];
        //view.textView.userInteractionEnabled = NO;
        _view = view;
        _name = name;
        
    }
    return self;
}

-(XYInputTextViewView*)view{
    return (XYInputTextViewView*)_view;
}

-(void)setValue:(NSString *)value{
    ((XYInputTextViewView*)_view).textView.text = value;
}

-(NSString*)value{
    return ((XYInputTextViewView*)_view).textView.text == nil ? @"" : ((XYInputTextViewView*)_view).textView.text;
}

-(void)setTextViewDelegate:(XYUITextViewDelegate *)textViewDelegate{
    _textViewDelegate = textViewDelegate;
    ((XYInputTextViewView*)_view).textView.delegate = _textViewDelegate;
}

-(void)clearValue{
    self.value = @"";
}

-(void)resignFirstResponder{
    [((XYInputTextViewView*)_view).textView resignFirstResponder];
}
-(void)setEditable:(BOOL)editable{
    _editable = editable;
    ((XYInputTextViewView*)_view).textView.editable = editable ;
    ((XYInputTextViewView*)_view).textView.userInteractionEnabled = editable;
}

@end

