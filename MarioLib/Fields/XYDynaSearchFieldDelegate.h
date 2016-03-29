//
//  XYDynaSearchFieldDelegate.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDynaSearchField.h"

@class XYDynaSearchField;

/**
 Protocol for XYDynaSearchField
 */
@protocol XYDynaSearchFieldDelegate <NSObject>
@required
/**
 Required, must return a list of XYLabelValue object or XYTableCell object
 Notice:
 The array list can contain both XYLabelValue and XYTableCell at same time.
 For XYLabelValue object, a default XYTableCell will be created during the rendering.
 For XYTableCell, you can set text/detailText value
 The value of selection will be taken from name field of the cell
 The text of selection will be taken from text field of the cell
 Additional information can be stored in property "object" of XYLabelValue or XYTableCell object. Use XYDynaSearchField selectedLabelValue.object property to retrieve.
 */
-(NSArray*)XYDynaSearchField:(XYDynaSearchField*)field getSearchResultListByText:(NSString*)text;


@optional
/**
 Optional, return BOOL value.
 If YES, the search logic(above method) will be triggered every N sec since editing, otherwise will be triggered immediately
 Value N is defined by default as 1.0.
 Value N can be defined by method -(NSTimeInterval)onlineSearchTimeInterval
 If this method is not implemented, default value is NO.
 */
-(BOOL)isOnlineSearchXYDynaSearchField:(XYDynaSearchField*)field;

/**
  The time interval for triggering the request
 */
-(NSTimeInterval)onlineSearchTimeIntervalForXYDynaSearchField:(XYDynaSearchField*)field;

/**
 Callback for item selected
 */
-(void)XYDynaSearchField:(XYDynaSearchField*)field didSelectXYTableCell:(XYTableCell*)cell;
@end
