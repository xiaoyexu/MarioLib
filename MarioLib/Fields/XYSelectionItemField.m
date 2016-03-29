//
//  XYSelectionItemField.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectionItemField.h"

@implementation XYSelectionItemField

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        view.label.text = label;
        view.textView.editable = NO;
        view.textView.userInteractionEnabled = NO;
        _view = view;
        _name = name;
        
    }
    return self;
}

@end

