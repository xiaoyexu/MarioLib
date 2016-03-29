//
//  XYSelectionItemTableCell.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectionItemTableCell.h"

@implementation XYSelectionItemTableCell
+(XYSelectionItemTableCell*)cellWithName:(NSString*)name view:(UIView*)view{
    XYSelectionItemTableCell* f = [[XYSelectionItemTableCell alloc] initWithView:view];
    f.name = name;
    return f;
}
+(XYSelectionItemTableCell*)cellWithName:(NSString*)name xyField:(XYField*)field{
    XYSelectionItemTableCell* f = [[XYSelectionItemTableCell alloc] initWithXYField:field];
    f.name = name;
    return f;
}
@end
