//
//  XYDynaSearchField.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAdvField.h"
#import "XYSelectorObject.h"
#import "XYUITextViewDelegate.h"
#import "XYUISelectionTextViewDelegate.h"
#import "XYInputTextViewView.h"
#import "XYDynaSearchFieldViewController.h"
#import "XYDynaSearchFieldDelegate.h"

@class XYUISelectionTextViewDelegate;

/**
 This class represents a dynamic search field, user need to enter text in search bar and select one from result list
 
 This field will store user entered string in userdefauts with key "<fieldname>RecentItems", the object is a NSArray with NSString objects in it. (See more detail in XYDynaSearchFieldViewController.m)
 */

@interface XYDynaSearchField : XYAdvField

@property (nonatomic,readonly) XYInputTextViewView* view;
@property (nonatomic,strong) XYUITextViewDelegate* textViewDelegate;
@property (nonatomic,strong) XYUISelectionTextViewDelegate* popOverTextViewDelegate;
@property (nonatomic) NSInteger minHeight;
@property (nonatomic) NSInteger maxHeight;

/**
 Selector for anything to do when item selected
 */
@property (nonatomic, readonly) XYSelectorObject*  selectionCompletedSelector;

/**
 Delegate for search logic
 */
@property (nonatomic,strong) id<XYDynaSearchFieldDelegate> delegate;

/**
 XYLabelValue object for selected item
 */
@property (nonatomic,strong) XYLabelValue* selectedLabelValue;

/**
 Maximum line
 */
@property (nonatomic) NSUInteger maxLine;

/**
 Search bar placeholder
 */
@property (nonatomic, strong) NSString* placeholder;

/**
 Whether search text history supported
 */
@property (nonatomic) BOOL enableSearchTextHistory;

/**
 Initialization method with field name, frame, label, ratio
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r;

/**
 Initialization method with field name, frame, label, ratio
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 @param delegate XYDynaSearchFieldDelegate delegate
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r delegate:(id<XYDynaSearchFieldDelegate>) delegate;

@end
