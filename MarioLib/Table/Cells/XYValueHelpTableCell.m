//
//  XYValueHelpTableCell.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/22/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYValueHelpTableCell.h"

@implementation XYValueHelpTableCell
+(XYValueHelpTableCell*)cellWithName:(NSString*)name view:(UIView*)view{
    XYValueHelpTableCell* f = [[XYValueHelpTableCell alloc] initWithView:view];
    f.name = name;
    return f;
}
+(XYValueHelpTableCell*)cellWithName:(NSString*)name XYField:(XYField*)field{
    XYValueHelpTableCell* f = [[XYValueHelpTableCell alloc] initWithXYField:field];
    f.name = name;
    return f;
}
@end
