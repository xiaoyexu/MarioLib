//
//  XYTableContainer.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableContainer.h"

@implementation XYTableContainer
@synthesize sections = _sections;
@synthesize fieldsDictionary = _fieldsDictionary;
@synthesize headerSections = _headerSections;
@synthesize footerSections = _footerSections;
-(id)init{
    if (self = [super init]) {
        _sections = [NSMutableArray new];
        _fieldsDictionary = [NSMutableDictionary new];
        _headerSections = [NSMutableArray new];
        _footerSections = [NSMutableArray new];
    }
    return self;
}

-(void)addXYTableSection:(XYTableSection*)section{
    [_sections addObject:section];
}

-(void)insertXYTableSection:(XYTableSection*)section atIndex:(NSUInteger)index{
    [_sections insertObject:section atIndex:index];
}

-(XYTableSection*)sectionAtRow:(NSInteger)row{
    return (XYTableSection*)[_sections objectAtIndex:row];
}
-(void)removeSectionAtRow:(NSInteger)row{
    [_sections removeObjectAtIndex:row];
}

-(void)removeAllSections{
    [_sections removeAllObjects];
}

-(void)addHeaderXYTableSection:(XYTableSection*)section{
    [_headerSections addObject:section];
}
-(XYTableSection*)HeaderSectionAtRow:(NSInteger)row{
    return (XYTableSection*)[_headerSections objectAtIndex:row];
}
-(void)removeHeaderSectionAtRow:(NSInteger)row{
    [_headerSections removeObjectAtIndex:row];
}

-(void)removeAllHeaderSections{
    [_headerSections removeAllObjects];
}
-(void)addFooterXYTableSection:(XYTableSection*)section{
    [_footerSections addObject:section];
}
-(XYTableSection*)FooterSectionAtRow:(NSInteger)row{
    return (XYTableSection*)[_footerSections objectAtIndex:row];
}
-(void)removeFooterSectionAtRow:(NSInteger)row{
    [_footerSections removeObjectAtIndex:row];
}

-(void)removeAllFooterSections{
    [_footerSections removeAllObjects];
}

-(void)addXYTableCellArray:(NSArray*)array{
    XYTableSection* sec = [XYTableSection new];
    for (XYTableCell* cell in array) {
        [self registerXYTableCell:cell];
    }
    [sec addCellArray:array];
    [_sections addObject:sec];
}

-(NSInteger)countOfActualSections{
    return [self actualSectionArray].count;
}

-(NSInteger)countOfActualRowsAtSection:(NSInteger)section{
    XYTableSection* sec = [[self actualSectionArray] objectAtIndex:section];
    NSInteger count = 0;
    for (XYTableCell* f in sec.fields) {
        if (!f.visible) {
            // Only count visible XYTableCell
            continue;
        }
        if ([f isKindOfClass:[XYDynamicTableCell class]]) {
            // For XYDynamicTableCell, get its actual cells
            count += [(XYDynamicTableCell*)f actualCellArray].count;
        } else if ([f isKindOfClass:[XYBubbleTableCell class]]) {
            // For a XYBubbleTableCell, each row is actually represented by multiply rows, convert to the XYDynamicTableCell field and count
            XYDynamicTableCell* dtc = [((XYBubbleTableCell*)f) dynamicTableCellPresentation];
            count += [dtc actualCellArray].count;
        } else {
            // Normally, each XYTableCell represent 1 row
            count++;
        }
    }
    return count;
}

-(NSMutableArray*)actualSectionArray{
    NSMutableArray* result = [NSMutableArray new];
    // Return the total sections
    [result addObjectsFromArray:[self actualSectionIn:_headerSections]];
    [result addObjectsFromArray:[self actualSectionIn:_sections]];
    [result addObjectsFromArray:[self actualSectionIn:_footerSections]];
    return result;
}

-(NSArray*)actualSectionIn:(NSMutableArray*)array{
    NSMutableArray* result = [NSMutableArray new];
    for (XYTableSection* sec in array){
        [result addObjectsFromArray:[sec actualSectionArray]];
    }
    return result;
}

-(NSMutableArray*)actualFieldArray{
    NSMutableArray* result = [NSMutableArray new];
    for (XYTableCell* field in [self actualSectionArray]) {
        if ([field isKindOfClass:[XYDynamicTableCell class]]) {
            XYDynamicTableCell* df = (XYDynamicTableCell*)field;
            [result addObjectsFromArray:[df actualCellArray]];
        } else {
            [result addObject:field];
        }
    }
    return result;
}

-(XYTableCell*)xyTableCellAtIndexPath:(NSIndexPath*)indexPath{
    XYTableSection* section = [[self actualSectionArray] objectAtIndex:indexPath.section];
    NSMutableArray* fields = [section actualCellArray];
    XYTableCell* field = (XYTableCell*)[fields objectAtIndex:indexPath.row];
    return field;
}

-(void)addXYTableCell:(XYTableCell*) cell Level :(XYViewLevel)level section:(NSInteger)section row:(NSInteger)row{
    NSMutableArray* sectionArray;
    switch (level) {
        case XYViewLevelHeader:{
            sectionArray = _headerSections;
        }
            break;
        case XYViewLevelWorkArea:{
            sectionArray = _sections;
        }
            break;
        case XYViewLevelFooter:{
            sectionArray = _footerSections;
        }
            break;
        default:
            return;
    }
    XYTableSection* secObj;
    if (section >= 0 && section < sectionArray.count) {
        secObj = [sectionArray objectAtIndex:section];
        if (row >= 0 && row < secObj.fields.count) {
            [secObj.fields insertObject:cell atIndex:row];
        } else {
            [secObj addCell:cell];
        }
    } else {
        secObj = [XYTableSection new];
        [secObj addCell:cell];
        [sectionArray addObject:secObj];
    }
    [self registerXYTableCell:cell];
}

-(void)addXYTableCell:(XYTableCell*)cell Level:(XYViewLevel)level section:(NSInteger)section{
    [self addXYTableCell:cell Level:level section:section row:-1];
}

-(void)addXYTableCell:(XYTableCell*)cell Level:(XYViewLevel)level{
    [self addXYTableCell:cell Level:level section:-1];
}

-(void)addXYTableCell:(XYTableCell*)cell{
    [self addXYTableCell:cell Level:XYViewLevelWorkArea];
}

-(void)addXYTableCellArray:(NSArray*)cells Level :(XYViewLevel)level section:(NSInteger)section row:(NSInteger)row{
    NSMutableArray* sectionArray;
    switch (level) {
        case XYViewLevelHeader:{
            sectionArray = _headerSections;
        }
            break;
        case XYViewLevelWorkArea:{
            sectionArray = _sections;
        }
            break;
        case XYViewLevelFooter:{
            sectionArray = _footerSections;
        }
            break;
        default:
            return;
    }
    XYTableSection* secObj;
    if (section >= 0 && section < sectionArray.count) {
        secObj = [sectionArray objectAtIndex:section];
        if (row >= 0 && row < secObj.fields.count) {
            [secObj.fields insertObjects:cells atIndexes:[NSIndexSet indexSetWithIndex:row]];
        } else {
            [secObj addCellArray:cells];
        }
    } else {
        secObj = [XYTableSection new];
        [secObj addCellArray:cells];
        [sectionArray addObject:secObj];
    }
    for (XYTableCell* cell in cells) {
        [self registerXYTableCell:cell];
    }
}

-(void)moveTableCellFrom:(NSIndexPath*)source to:(NSIndexPath*)dest{
    XYTableSection* sectionSrc = [[self actualSectionArray] objectAtIndex:source.section];
    
    XYTableSection* sectionDest = [[self actualSectionArray] objectAtIndex:dest.section];
    if (sectionSrc != sectionDest) {
        return;
    }
    // Can only move within same section
    [sectionSrc moveCellFrom:source to:dest];
}

-(void)registerXYTableCell:(XYTableCell*)field{
    [_fieldsDictionary setObject:field forKey:field.name];
}
-(void)unregisterXYTableCell:(XYTableCell *)field{
    [_fieldsDictionary removeObjectForKey:field.name];
}
-(XYTableCell*)xyTableCellByName:(NSString*)name{
    return [_fieldsDictionary objectForKey:name];
}
-(NSString*)xyTableCellValueByName:(NSString*)name{
    XYTableCell* f = [self xyTableCellByName:name];
    if (f.field == nil) {
        return @"";
    }
    return f.field.value;
    
}

-(void)setXYTableCell:(NSString*) name value:(NSString*)value{
    XYTableCell* f = [self xyTableCellByName:name];
    if (f.field != nil) {
        f.field.value = value;
    }
}

-(void)registerFieldsInSection:(XYTableSection*)section{
    for (XYTableCell* f in section.headerExtraSection) {
        [self registerXYTableCell:f];
    }
    for (XYTableCell* f in section.fields) {
        [self registerXYTableCell:f];
    }
    for (XYTableCell* f in section.footerExtraSection) {
        [self registerXYTableCell:f];
    }
    
}

-(void)removeXYTableCellAtIndexPath:(NSIndexPath*)indexPath{
    XYTableSection* section = [[self actualSectionArray] objectAtIndex:indexPath.section];
    XYTableCell* cellToDelete = [[section actualCellArray] objectAtIndex:indexPath.row];
    [section removeCell:cellToDelete];
}

@end
