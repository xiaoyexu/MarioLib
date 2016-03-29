//
//  XYExpandableTableCell.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYExpandableTableCell.h"

@implementation XYExpandableTableCell
@synthesize isExpanded = _isExpanded;
@synthesize maxHeight = _maxHeight;
@synthesize minHeight = _minHeight;

+(id)cellWithName:(NSString*)name view:(UIView*)view{
    XYExpandableTableCell* f = [[XYExpandableTableCell alloc] initWithView:view];
    f.name = name;
    f.selectable = YES;
    return f;
}
+(id)cellWithName:(NSString*)name xyField:(XYField*)field{
    XYExpandableTableCell* f = [[XYExpandableTableCell alloc] initWithXYField:field];
    f.name = name;
    f.selectable = YES;
    return f;
}

-(void)setIsExpanded:(BOOL)isExpanded{
    _isExpanded = isExpanded;
}

-(NSInteger)maxHeight{
    return _view == nil ? self.height : (_maxHeight > 0 ? _maxHeight : _view.frame.size.height);
}

-(void)setMinHeight:(NSInteger)minHeight{
    _minHeight = minHeight;
    if (_height == 0) {
        _height = minHeight;
    }
}

@end
