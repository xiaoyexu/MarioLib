//
//  XYDynamicTableCell.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableCell.h"

/**
 This class represents a cell that can be expanded/collapsed
 */
@interface XYDynamicTableCell : XYTableCell
{
    NSMutableArray* _headerExtraCell;
    NSMutableArray* _footerExtraCell;
}
@property (nonatomic) BOOL showHeaderExtraCell;
@property (nonatomic) BOOL showFooterExtraCell;
@property (nonatomic) NSInteger headerDisplayRowNumber;
@property (nonatomic) NSInteger footerDisplayRowNumber;
@property (nonatomic) BOOL isHeaderExpanded;
@property (nonatomic) BOOL isFooterExpanded;
@property (nonatomic) BOOL showAccessoryButton;
@property (nonatomic) BOOL clickToFold;

// Add/remove/count header cell
-(void)addHeaderExtraCell:(XYTableCell*)cell;
-(XYTableCell*)headerExtraCellAtRow:(NSInteger)row;
-(void)removeHeaderExtraCellAtRow:(NSInteger)row;
-(void)removeAllHeaderExtraCell;
-(NSInteger)countOfHeaderExtraCell;

// Add/remove/count footer cell
-(void)addFooterExtraCell:(XYTableCell*)cell;
-(XYTableCell*)footerExtraCellAtRow:(NSInteger)row;
-(void)removeFooterExtraCellAtRow:(NSInteger)row;
-(void)removeAllFooterExtraCell;
-(NSInteger)countOfFooterExtraCell;

/**
 @return actual cell count
 */
-(NSInteger)count;

/**
 @return actual cell array
 */
-(NSMutableArray*)actualCellArray;

/**
 Remove a XYTableCell
 */
-(void)removeXYTableCell:(XYTableCell*)cell;

/**
 Move XYTableCell
 */
-(void)moveXYTableCell:(XYTableCell*)source to:(XYTableCell*) dest;
@end

