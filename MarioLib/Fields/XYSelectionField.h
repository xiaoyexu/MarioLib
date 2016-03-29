//
//  XYSelectionField.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAdvField.h"
#import "XYSelectionField.h"
#import "XYSelectionItemField.h"
#import "XYUITextViewDelegate.h"
#import "XYInputTextViewView.h"
#import "XYLabelValue.h"
#import "XYSelectionListViewController.h"
#import "XYUISelectionTextViewDelegate.h"
#import "XYSelectorObject.h"
#import "XYSelectionFieldDataSource.h"

@class XYUISelectionTextViewDelegate;
@class XYSelectionFieldDataSource;

/**
 XYSelectionField provide selection feature on iphone and ipad.
 On iphone:
   Please do not use it directly, use cellOfSelection:... in XYTableCellFactory and add XYSelectionTableCell in XYBaseUITableViewController
 
 On ipad:
   Either use XYBaseUITableViewController, or add it's view on the screen, a popover view controller will be used
 
 */
@interface XYSelectionField : XYAdvField

/**
 Whether is single selection
 */
@property (nonatomic) BOOL isSingleSelection;

/**
 Selection array of XYSelectionItemField class
 */
@property (nonatomic,readonly) NSArray* selection;

/**
 Selected NSIndexPath set
 Use method setSelected unsetSelected for selected indexpath
 Otherwise manually call renderFieldView
 */
@property (nonatomic,strong) NSMutableSet* selectedIndexPath;

/**
 Text view delegate
 */
@property (nonatomic,strong) XYUITextViewDelegate* textViewDelegate;

/**
 Text view delegate for situation that popover view controller used
 */
@property (nonatomic,strong) XYUISelectionTextViewDelegate* popOverTextViewDelegate;

/**
 Minimum height
 */
@property (nonatomic) NSInteger minHeight;

/**
 Maximum height
 */
@property (nonatomic) NSInteger maxHeight;

/**
 Selector logic when item selected
 */
@property (nonatomic, readonly) XYSelectorObject*  selectionCompletedSelector;

/**
 Whether selection item can be deleted
 */
@property (nonatomic) BOOL selectionItemDeletable;

/**
 Selector logic when item deleted
 */
@property (nonatomic, readonly) XYSelectorObject*  selectionItemDeletedSelector;


@property (nonatomic, strong) id<XYSelectionFieldDataSource> dataSource;

/**
 Initialization method with field name, frame, label, ratio
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r;

/**
 Initialization method
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 @param singleSelection Whether field is single selection
 @param selection NSArray for selection
 @param selectedIndexPaths NSIndexPath for item selected
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r singleSelection:(BOOL)singleSelection selectionArray:(NSArray*) selection selectedIndexPaths:(NSSet*) indexSet;

/**
 Initialization method
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 @param singleSelection Whether field is single selection
 @param selection NSDictionary for selection
 @param selectedIndexPaths NSIndexPath for item selected
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r singleSelection:(BOOL)singleSelection selectionDictionary:(NSDictionary*) selection selectedIndexPaths:(NSSet*) indexSet;

/**
 Set value of field
 @param value The selected item value
 */
-(void)setValue:(NSString *)value;

/**
 Return selected item value, not label
 */
-(NSString*)value;

/**
 Set selected index path
 */
-(void)setSelected:(NSIndexPath*)indexPath,... NS_REQUIRES_NIL_TERMINATION;

/**
 Unset selected index path
 */
-(void)unsetSelected:(NSIndexPath*)indexPath,... NS_REQUIRES_NIL_TERMINATION;

/**
 Set selection by array
 Could be:
 1) XYSelectionItemField array
 2) XYLabelValue array
 3) NSString array, key and value will be same
 */
-(void)setSelectionByArray:(NSArray*)selectionArray;

/**
 Set selection by dictionary
 */
-(void)setSelectionByDictionary:(NSDictionary*)selectionDictionary;

/**
 Add selector for item deleted
 */
-(void)addSelectionDeletedTarget:(id)target action:(SEL) selector;
@end
