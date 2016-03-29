//
//  XYDynamicTableCell.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYDynamicTableCell.h"

@implementation XYDynamicTableCell
@synthesize showHeaderExtraCell = _showHeaderExtraCell;
@synthesize showFooterExtraCell = _showFooterExtraCell;
@synthesize headerDisplayRowNumber = _headerDisplayRowNumber;
@synthesize footerDisplayRowNumber = _footerDisplayRowNumber;
@synthesize isHeaderExpanded = _isHeaderExpanded;
@synthesize isFooterExpanded = _isFooterExpanded;
@synthesize showAccessoryButton = _showAccessoryButton;
@synthesize clickToFold = _clickToFold;

-(id)init{
    if (self = [super init]) {
        _headerExtraCell = [NSMutableArray new];
        _footerExtraCell = [NSMutableArray new];
    }
    return self;
}

-(id)initWithView:(UIView*)view{
    if (self = [super initWithView:view]) {
        _headerExtraCell = [NSMutableArray new];
        _footerExtraCell = [NSMutableArray new];
    }
    return self;
}

-(id)initWithXYField:(XYField *)field{
    if (self = [super initWithXYField:field]) {
        _headerExtraCell = [NSMutableArray new];
        _footerExtraCell = [NSMutableArray new];
    }
    return self;
}

-(void)renderCell{
    [super renderCell];
    self.editable = NO;
    self.movable = NO;
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    self.showAccessoryButton = YES;
}

+(id)cellWithName:(NSString*)name view:(UIView*)view{
    XYDynamicTableCell* f = [[XYDynamicTableCell alloc] initWithView:view];
    f.name = name;
    return f;
}
+(id)cellWithName:(NSString*)name xyField:(XYField*)field{
    XYDynamicTableCell* f = [[XYDynamicTableCell alloc] initWithXYField:field];
    f.name = name;
    return f;
}

-(void)addHeaderExtraCell:(XYTableCell*)cell{
    cell.visible = NO;
    cell.superCell = self;
    [_headerExtraCell addObject:cell];
}
-(XYTableCell*)headerExtraCellAtRow:(NSInteger)row{
    return (XYTableCell*)[_headerExtraCell objectAtIndex:row];
}
-(void)removeHeaderExtraCellAtRow:(NSInteger)row{
    [_headerExtraCell removeObjectAtIndex:row];
}

-(void)removeAllHeaderExtraCell{
    [_headerExtraCell removeAllObjects];
}

-(NSInteger)countOfHeaderExtraCell{
    return _headerExtraCell.count;
}

-(void)addFooterExtraCell:(XYTableCell*)cell{
    cell.visible = NO;
    cell.superCell = self;
    [_footerExtraCell addObject:cell];
}
-(XYTableCell*)footerExtraCellAtRow:(NSInteger)row{
    return (XYTableCell*)[_footerExtraCell objectAtIndex:row];
}
-(void)removeFooterExtraCellAtRow:(NSInteger)row{
    [_footerExtraCell removeObjectAtIndex:row];
}

-(void)removeAllFooterExtraCell{
    [_footerExtraCell removeAllObjects];
}
-(NSInteger)countOfFooterExtraCell{
    return _footerExtraCell.count;
}

-(NSInteger)count{
    return [self actualCellArray].count;
}

/*
  Return all visible fields in total
 */
-(NSMutableArray*)actualCellArray{
    NSMutableArray* result = [NSMutableArray new];
    for (int i = 0; i < _headerExtraCell.count; i++) {
        XYTableCell* f = [_headerExtraCell objectAtIndex:i];
        if (i < _headerDisplayRowNumber) {
            f.visible = YES;
        } 
        if (f.visible) {
            [result addObject:f];
        }
    }
    if (self.visible) {
        [result addObject:self];
    }
    for (int i = 0; i < _footerExtraCell.count; i++) {
        XYTableCell* f = [_footerExtraCell objectAtIndex:i];
        if (i < _footerDisplayRowNumber) {
            f.visible = YES;
        }
        if (f.visible) {
            [result addObject:f];
        }
    }
    return result;
}

-(void)removeXYTableCell:(XYTableCell*)cell{
    [_headerExtraCell removeObject:cell];
    [_footerExtraCell removeObject:cell];
}

/*
  Move XYTableCell to another location
 */
-(void)moveXYTableCell:(XYTableCell*)source to:(XYTableCell*) dest{
    NSUInteger sourceIndex = [_headerExtraCell indexOfObject:source];
    NSUInteger destIndex = [_headerExtraCell indexOfObject:dest];
    // 4 conditions
    if (sourceIndex == NSNotFound && destIndex == NSNotFound) {
        // 1: Moving in footer array
        sourceIndex = [_footerExtraCell indexOfObject:source];
        destIndex = [_footerExtraCell indexOfObject:dest];
        if (sourceIndex != NSNotFound && destIndex != NSNotFound) {
            id objsrc = [_footerExtraCell objectAtIndex:sourceIndex];
            id objdest = [_footerExtraCell objectAtIndex:destIndex];
            if (objsrc != nil && objdest != nil) {
                [_footerExtraCell removeObject:objsrc];
                [_footerExtraCell insertObject:objsrc atIndex:destIndex];
                return;
            }
        }
    } else if (sourceIndex == NSNotFound && destIndex != NSNotFound){
        // 2: Moving from footer to header array
        sourceIndex = [_footerExtraCell indexOfObject:source];
        if (sourceIndex != NSNotFound && destIndex != NSNotFound) {
            id objsrc = [_footerExtraCell objectAtIndex:sourceIndex];
            id objdest = [_headerExtraCell objectAtIndex:destIndex];
            if (objsrc != nil && objdest != nil) {
                [_footerExtraCell removeObject:objsrc];
                [_headerExtraCell insertObject:objsrc atIndex:destIndex];
                return;
            }
        }
    } else if (sourceIndex != NSNotFound && destIndex != NSNotFound) {
        // 3: Moving in header array
        id objsrc = [_headerExtraCell objectAtIndex:sourceIndex];
        id objdest = [_headerExtraCell objectAtIndex:destIndex];
        if (objsrc != nil && objdest != nil) {
            [_headerExtraCell removeObject:objsrc];
            [_headerExtraCell insertObject:objsrc atIndex:destIndex];
            return;
        }
    } else if (sourceIndex != NSNotFound && destIndex == NSNotFound){
        // 4: Moving from header to footer array
        destIndex = [_footerExtraCell indexOfObject:dest];
        if (sourceIndex != NSNotFound && destIndex != NSNotFound) {
            id objsrc = [_headerExtraCell objectAtIndex:sourceIndex];
            id objdest = [_footerExtraCell objectAtIndex:destIndex];
            if (objsrc != nil && objdest != nil) {
                [_headerExtraCell removeObject:objsrc];
                [_footerExtraCell insertObject:objsrc atIndex:destIndex];
                return;
            }
        }
    }
}

/*
  Decide whether to show accessory button
 */
-(BOOL)showAccessoryButton{
    if (_footerDisplayRowNumber > 0 && _footerExtraCell.count <= _footerDisplayRowNumber) {
        return NO;
    }
    if (_headerDisplayRowNumber > 0 && _headerExtraCell.count <= _headerDisplayRowNumber) {
        return NO;
    }
    return _showAccessoryButton;
}

@end

