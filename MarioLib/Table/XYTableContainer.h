//
//  XYTableContainer.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDesighHeader.h"
#import "XYTableSection.h"

/**
 This class represents a container where all XYTableCell are managed
 */
@interface XYTableContainer : NSObject
/**
 Array for sections
 */
@property (nonatomic,readonly) NSMutableArray* sections;

/**
 Dictionary for each XYTableCell, key is name
 */
@property (nonatomic,readonly) NSMutableDictionary* fieldsDictionary;

/**
 Array for header sections
 */
@property (nonatomic,readonly) NSMutableArray* headerSections;

/**
 Array for footer sections
 */
@property (nonatomic,readonly) NSMutableArray* footerSections;

/**
 Initialization method
 */
-(id)init;

// Add/remove section
-(void)addXYTableSection:(XYTableSection*)section;
-(void)insertXYTableSection:(XYTableSection*)section atIndex:(NSUInteger)index;
-(XYTableSection*)sectionAtRow:(NSInteger)row;
-(void)removeSectionAtRow:(NSInteger)row;
-(void)removeAllSections;

// Add/remove header section
-(void)addHeaderXYTableSection:(XYTableSection*)section;
-(XYTableSection*)HeaderSectionAtRow:(NSInteger)row;
-(void)removeHeaderSectionAtRow:(NSInteger)row;
-(void)removeAllHeaderSections;

// Add/remove footer section
-(void)addFooterXYTableSection:(XYTableSection*)section;
-(XYTableSection*)FooterSectionAtRow:(NSInteger)row;
-(void)removeFooterSectionAtRow:(NSInteger)row;
-(void)removeAllFooterSections;

/**
 Add XYTabelCell from array
 */
-(void)addXYTableCellArray:(NSArray*)array;

/**
 Count of actual sections
 */
-(NSInteger)countOfActualSections;

/**
 Count of actual row in a certain section
 */
-(NSInteger)countOfActualRowsAtSection:(NSInteger)section;

/**
 @return section array
 */
-(NSMutableArray*)actualSectionArray;

/**
 @return XYTableCell by indexPath
 */
-(XYTableCell*)xyTableCellAtIndexPath:(NSIndexPath*)indexPath;

/**
 Move XYTableCell object
 */
-(void)moveTableCellFrom:(NSIndexPath*)source to:(NSIndexPath*)dest;

// Add XYTableCell
// section, row can be -1 as appending
-(void)addXYTableCell:(XYTableCell*)cell Level:(XYViewLevel)level section:(NSInteger)section row:(NSInteger)row;
-(void)addXYTableCellArray:(NSArray*)cells Level :(XYViewLevel)level section:(NSInteger)section row:(NSInteger)row;
-(void)addXYTableCell:(XYTableCell*)cell Level:(XYViewLevel)level section:(NSInteger)section;
-(void)addXYTableCell:(XYTableCell*)cell Level:(XYViewLevel)level;
-(void)addXYTableCell:(XYTableCell*)cell;

/**
 Register XYTableCell in dictionary
 */
-(void)registerXYTableCell:(XYTableCell*)cell;

/**
 Unregister XYTableCell in dictionary
 */
-(void)unregisterXYTableCell:(XYTableCell*)cell;

/**
 Get XYTableCell by name
 */
-(XYTableCell*)xyTableCellByName:(NSString*)name;

/**
 Get XYTableCell field value by name
 */
-(NSString*)xyTableCellValueByName:(NSString*)name;

/**
 Set XYTableCell field value by name
 */
-(void)setXYTableCell:(NSString*) name value:(NSString*)value;

/**
 Remove a certain XYTableCell by indexPath
 */
-(void)removeXYTableCellAtIndexPath:(NSIndexPath*)indexPath;
@end

