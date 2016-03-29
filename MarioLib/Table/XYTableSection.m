//
//  XYTableSection.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableSection.h"

@implementation XYTableSection
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;
@synthesize name = _name;
@synthesize fields = _fields;
@synthesize headerExtraSection = _headerExtraSection;
@synthesize footerExtraSection = _footerExtraSection;
@synthesize showHeaderExtraSection = _showHeaderExtraSection;
@synthesize showFooterExtraSection = _showFooterExtraSection;
@synthesize visible = _visible;
-(id)init{
    self = [super init];
    if (self) {
        _fields = [NSMutableArray new];
        _headerExtraSection = [NSMutableArray new];
        _footerExtraSection = [NSMutableArray new];
        _visible = YES;
    }
    return self;
}

+(id)sectionWithName:(NSString*) name headerTitle:(NSString*) header footerTitler:(NSString*) footer{
    XYTableSection* section = [XYTableSection new];
    section.name = name;
    section.headerTitle = header;
    section.footerTitle = footer;
    return section;
}

-(void)setShowHeaderExtraSection:(BOOL)showHeaderExtraSection{
    _showHeaderExtraSection = showHeaderExtraSection;
    for (XYTableCell* f in _headerExtraSection) {
        f.visible = YES;
    }
}

-(void)setShowFooterExtraSection:(BOOL)showFooterExtraSection{
    _showFooterExtraSection = showFooterExtraSection;
    for (XYTableCell* f in _footerExtraSection) {
        f.visible = YES;
    }
}

-(void)addCell:(XYTableCell*)field{
    [self.fields addObject:field];
}
-(void)addCellArray:(NSArray*)array{
    [self.fields addObjectsFromArray:array];
}
-(XYTableCell*)fieldAtRow:(NSInteger)row{
    return (XYTableCell*)[self.fields objectAtIndex:row];
}

-(void)removeCellAtRow:(NSInteger)row{
    [self.fields removeObjectAtIndex:row];
}

-(void)removeAll{
    [self.fields removeAllObjects];
}

-(void)addHeaderExtraSection:(XYTableSection*)section{
    [self.headerExtraSection addObject:section];
}
-(XYTableSection*)headerExtraSectionAtRow:(NSInteger)row{
    return (XYTableSection*)[self.headerExtraSection objectAtIndex:row];
}
-(void)removeHeaderExtraSectionAtRow:(NSInteger)row{
    [self.headerExtraSection removeObjectAtIndex:row];
}

-(void)removeAllHeaderExtraSection{
    [self.headerExtraSection removeAllObjects];
}

-(void)addFootExtraSection:(XYTableSection*)section{
    [self.footerExtraSection addObject:section];
}
-(XYTableSection*)footerExtraSectionAtRow:(NSInteger)row{
    return (XYTableSection*)[self.footerExtraSection objectAtIndex:row];
}
-(void)removeFooterExtraSectionAtRow:(NSInteger)row{
    [self.footerExtraSection removeObjectAtIndex:row];
}
-(void)removeAllFooterExtraSection{
    [self.footerExtraSection removeAllObjects];
}
-(NSInteger)count{
    return [self actualSectionArray].count;
}
-(NSMutableArray*)actualSectionArray{
    NSMutableArray* result = [NSMutableArray new];
    if (_showHeaderExtraSection) {
        for (XYTableSection* sec in _headerExtraSection) {
            if (sec.visible /*&& [sec actualCellArray].count != 0*/) {
                [result addObject:sec];
            }
        }
    }
    if (self.visible /*&& [self actualCellArray].count != 0*/) {
        [result addObject:self];
    }
    if (_showFooterExtraSection) {
        for (XYTableSection* sec in _footerExtraSection) {
            if (sec.visible /*&& [sec actualCellArray].count != 0*/) {
                [result addObject:sec];
            }
        }
    }
    return result;
}

//-(BOOL)visible{
//    // Check if only contain one cell, visiblity will depended on this cell
//    NSArray* actualCellArray = [self actualCellArray];
//    if (actualCellArray.count == 1) {
//        XYTableCell* cell = [actualCellArray objectAtIndex:0];
//        return cell.visible;
//    }
//    return _visible;
//}

-(BOOL)hasVisibleTableCell{
    for (XYTableCell* cell in [self actualCellArray]) {
        if (cell.visible) {
            return YES;
        }
    }
    return NO;
}

-(NSMutableArray*)actualCellArray{
    NSMutableArray* result = [NSMutableArray new];
    for (XYTableCell* field in self.fields) {
        if ([field isKindOfClass:[XYDynamicTableCell class]]) {
            XYDynamicTableCell* df = (XYDynamicTableCell*)field;
            [result addObjectsFromArray:[df actualCellArray]];
        } else if ([field isKindOfClass:[XYBubbleTableCell class]]) {
            XYDynamicTableCell* df = [((XYBubbleTableCell*)field) dynamicTableCellPresentation];
            [result addObjectsFromArray:[df actualCellArray]];
        } else {
            if (field.visible) {
                [result addObject:field];
            }
        }
    }
    return result;
}

-(void)removeCell:(XYTableCell*)cell{
    [_fields removeObject:cell];
    for (XYTableCell* field in self.fields) {
        if ([field isKindOfClass:[XYDynamicTableCell class]]) {
            XYDynamicTableCell* df = (XYDynamicTableCell*)field;
            [df removeXYTableCell:cell];
        }
    }
}

-(void)moveCellFrom:(NSIndexPath*)sourceIndexPath to:(NSIndexPath*)destIndexPath{

    XYTableCell* objsrc = [[self actualCellArray] objectAtIndex:sourceIndexPath.row];
    XYTableCell* objdest = [[self actualCellArray] objectAtIndex:destIndexPath.row];
        
    if (objsrc != nil && objdest != nil && (objsrc.superCell == nil && objdest.superCell == nil)) {
        // Normal cell move
        [_fields removeObject:objsrc];
        [_fields insertObject:objsrc atIndex:destIndexPath.row];
        return;
    }
    if (objsrc.superCell == objdest.superCell && [objsrc.superCell isKindOfClass:[XYDynamicTableCell class]]) {
        [((XYDynamicTableCell*)objsrc.superCell) moveXYTableCell:objsrc to:objdest];
    }
}
@end

