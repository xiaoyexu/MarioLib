//
//  XYSelectionTableCell.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectionTableCell.h"

@implementation XYSelectionTableCell
@synthesize triggerByAccessoryButton = _triggerByAccessoryButton;
@synthesize popOverOptionView = _popOverOptionView;

+(XYSelectionTableCell*)cellWithName:(NSString*)name view:(UIView*)view{
    XYSelectionTableCell* f = [[XYSelectionTableCell alloc] initWithView:view];
    f.name = name;
    return f;
}
+(XYSelectionTableCell*)cellWithName:(NSString*)name xyField:(XYField*)field{
    XYSelectionTableCell* f = [[XYSelectionTableCell alloc] initWithXYField:field];
    f.name = name;
    return f;
}

-(void)setEditable:(BOOL)editable{
    _editable = editable;
    self.selectable = editable;
}

@end
