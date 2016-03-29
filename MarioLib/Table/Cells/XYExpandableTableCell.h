//
//  XYExpandableTableCell.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableCell.h"

/**
 Special type XYExpandableTableCell, represents the cell can be expanded or collapsed
 */
@interface XYExpandableTableCell : XYTableCell
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) NSInteger maxHeight;
@property (nonatomic) NSInteger minHeight;
@end
