//
//  XYField.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import "XYField.h"

@implementation XYField
@synthesize view = _view;
@synthesize name = _name;
@synthesize value = _value;
@synthesize editable = _editable;
@synthesize tableCell = _tableCell;
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithName:(NSString*)name{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

-(id)initWithName:(NSString*)name frame:(CGRect)f ratio:(float) r{
    if (self = [super init]) {
        _name = name;
        _view = [[XYFieldView alloc] initWithFrame:f andRatio:r];
    }
    return self;
}

-(void)clearValue{
    _value = @"";
}
-(void)resignFirstResponder{
    for (UIView* v in _view.subviews) {
        [v resignFirstResponder];
    }
}
@end

