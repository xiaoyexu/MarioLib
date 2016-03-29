//
//  XYTableCell.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableCell.h"

@implementation XYTableCell

@synthesize name = _name;
@synthesize type = _type;
@synthesize object = _object;
@synthesize superCell = _superCell;
@synthesize text = _text;
@synthesize detailText = _detailText;
@synthesize attributedText = _attributedText;
@synthesize attributedDetailText = _attributedDetailText;
@synthesize backgroundColor = _backgroundColor;
@synthesize viewAsBackgroundView = _viewAsBackgroundView;
@synthesize view = _view;
@synthesize field = _field;
@synthesize cellIdentifier = _cellIdentifier;
@synthesize customizedCellForRow = _customizedCellForRow;
@synthesize height = _height;
@synthesize selectable = _selectable;
@synthesize autoDeselected = _autoDeselected;
@synthesize selectionStyle = _selectionStyle;
@synthesize visible = _visible;
@synthesize editable = _editable;
@synthesize style = _style;
@synthesize editingStyle = _editingStyle;
@synthesize movable = _movable;
@synthesize accessoryType = _accessoryType;
-(id)init{
    if (self = [super init]) {
        _name = @"";
        [self renderCell];
    }
    return self;
}

-(id)initWithView:(UIView*)view{
    if (self = [super init]) {
        _name = @"";
        _view = view;
        [self renderCell];
    }
    return self;
}

-(id)initWithXYField:(XYField*)field{
    if (self = [super init]) {
        _name = @"";
        _field = field;
        field.tableCell = self;
        field != nil && (_view = field.view);
        [self renderCell];
    }
    return self;
}

-(void)renderCell{
    self.selectable = _view == nil;
    self.autoDeselected = YES;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.visible = YES;
    self.editable = YES;
    self.editingStyle = UITableViewCellEditingStyleDelete;
    self.movable = YES;
    
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        self.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:0.2];
    }
    self.accessoryType = UITableViewCellAccessoryNone;
}

+(id)cellWithName:(NSString*)name view:(UIView*)view{
    XYTableCell* f = [[XYTableCell alloc] initWithView:view];
    f.name = name;
    return f;
}
+(id)cellWithName:(NSString*)name xyField:(XYField*)field{
    XYTableCell* f = [[XYTableCell alloc] initWithXYField:field];
    f.name = name;
    return f;
}

-(void)setView:(UIView *)view{
    _view = view;
}

-(void)setXYField:(XYField*)field{
    _field = field;
    _view = field.view;
}
-(void)setHeight:(NSInteger)height{
    _height = height;
}

-(NSInteger)height{
    return _view.frame.size.height > _height ? _view.frame.size.height : _height == 0 ? 44 : _height;
}

-(void)resignFirstResponder{
    if (_field != nil) {
        [_field resignFirstResponder];
    }
}

-(void)clearValue{
    if (_field != nil) {
        [_field clearValue];
    }
}

-(void)setText:(NSString *)text{
    _text = text;
}

-(void)setEditable:(BOOL)editable{
    _editable = editable;
}
@end
