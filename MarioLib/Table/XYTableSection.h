//
//  XYTableSection.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYTableCell.h"
#import "XYBubbleTableCell.h"
#import "XYDynamicTableCell.h"

/**
 This class represents a section
 */
@interface XYTableSection : NSObject
@property (nonatomic,strong) NSString* headerTitle;
@property (nonatomic,strong) NSString* footerTitle;
@property (nonatomic,strong) UIView* headerView;
@property (nonatomic,strong) UIView* footerView;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,readonly) NSMutableArray* fields;
@property (nonatomic,readonly) NSMutableArray* headerExtraSection;
@property (nonatomic,readonly) NSMutableArray* footerExtraSection;
@property (nonatomic) BOOL showHeaderExtraSection;
@property (nonatomic) BOOL showFooterExtraSection;
@property (nonatomic) BOOL visible;

/**
 Initialization method
 */
-(id)init;

/**
 Static method to create a section
 */
+(id)sectionWithName:(NSString*) name headerTitle:(NSString*) header footerTitler:(NSString*) footer;
-(void)addCell:(XYTableCell*)field;
-(void)addCellArray:(NSArray*)array;
-(XYTableCell*)fieldAtRow:(NSInteger)row;
-(void)removeCellAtRow:(NSInteger)row;
-(void)removeAll;

-(void)addHeaderExtraSection:(XYTableSection*)section;
-(XYTableSection*)headerExtraSectionAtRow:(NSInteger)row;
-(void)removeHeaderExtraSectionAtRow:(NSInteger)row;
-(void)removeAllHeaderExtraSection;

-(void)addFootExtraSection:(XYTableSection*)section;
-(XYTableSection*)footerExtraSectionAtRow:(NSInteger)row;
-(void)removeFooterExtraSectionAtRow:(NSInteger)row;
-(void)removeAllFooterExtraSection;
-(void)removeCell:(XYTableCell*)cell;

-(NSInteger)count;
/**
 @return actual section, as each section may have extra header and footer section
 */
-(NSMutableArray*)actualSectionArray;

/**
 @return actual rows, as each row may have extra header and footer row
 */
-(NSMutableArray*)actualCellArray;

/**
  Method for moving a cell from source to destination
 */
-(void)moveCellFrom:(NSIndexPath*)sourceIndexPath to:(NSIndexPath*)destIndexPath;

/**
  @return if the section contains visiable table cell
 */
-(BOOL)hasVisibleTableCell;
@end

