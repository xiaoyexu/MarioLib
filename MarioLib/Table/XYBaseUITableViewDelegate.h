//
//  XYBaseUITableViewDelegate.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYBusyProcessorDelegate.h"
#import "XYTableCell.h"
#import "XYDummyTableCell.h"
#import "XYExpandableTableCell.h"
#import "XYRollableTableCell.h"
#import "XYButtonTableCell.h"
#import "XYTableContainer.h"
#import "XYActivityIndicatorView.h"
#import "XYBaseUITableViewMethods.h"
#import "XYBaseUIViewController.h"
#import "XYSelectionTableCell.h"
#import "XYSelectionItemTableCell.h"
#import "XYSelectionField.h"
#import "XYSideView.h"
//#import "XYFavCustomerView.h"
#import "XYBubbleView.h"

#define kDefaultTableViewHeaderHeight 28
#define kDefaultTableViewFooterHeight 28

@class XYBaseUITableViewController;

/**
 This class implemented table view datasource and delegate for XYTableCell usage
 The purpose of creating such delegate is to add input fields in a generic way into table view
 */
@interface XYBaseUITableViewDelegate : NSObject <UITableViewDataSource,UITableViewDelegate>
{
@protected
    XYButtonTableCell* loadMoreBtn;
    NSInteger lastSection;
    NSInteger lastRowInLastSection;
    UIViewController* _controller;
    BOOL loadMoreInProgress;
    
    // Store drag start point
    CGPoint dragStartPoint;
    // Store the Y-axis offset value of drag and drop
    NSInteger dragOffsetY;
    
    // View on the top/bottom of table
    XYSideView* _topView;
    XYSideView* _bottomView;

}

/**
 The container for table cells
 */
@property (nonatomic, strong) XYTableContainer* container;

/**
 A reference to controller, must set
 */
@property (nonatomic,strong) UIViewController* controller;

/**
 A reference to tableView, must set
 */
@property (nonatomic,strong) UITableView* tableView;

/**
 TableViewCell style, used in initializing UITableViewCell
 If not set, it will be filled by finding UITableViewCell automatically
 */
@property (nonatomic) UITableViewCellStyle cellStyle;

/**
 A flag to indicate if "Load More" button enabled
 */
@property (nonatomic) BOOL loadMoreButtonEnabled;

/**
 A flag to indicate if "Drill down to refresh" enabled
 */
@property (nonatomic) BOOL topViewEnabled;

/**
 A flag to indicate if "Pull up to load more" enabled
 */
@property (nonatomic) BOOL bottomViewEnabled;

/**
 The view for "Drill down to refresh"
 */
@property (nonatomic, readonly) XYSideView* topView;

/**
 The view for "Pull up to load more"
 */
@property (nonatomic, readonly) XYSideView* bottomView;

/**
 If this flag is on, 'swipe to delete' is enabled and depened on XYTableCell.editable value
 */
@property (nonatomic) BOOL enableSwipeToDelete;
/**
 Initialization method
 */
-(id)init;

/**
 Initialize with table contrainer and tableview etc
 */
-(id)initWithTableContainer:(XYTableContainer*)container;

// TableView delegates methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

/**
 Method to clear all fields added
 */
-(void)clearAllFields;

/**
 Method to resign all first responder inside UITableViewCell
 E.g. A text input field inside
 */
-(void)resignAllFirstResponder;

/**
 Check if the row is "Load More" row. This button is always at the end of table
 */
-(BOOL)isLoadMoreRow:(NSIndexPath*)indexPath;

/**
 A general method when XYTableCell be selected. It can be overwritten by sub class to extend
 */
- (void)didSelectXYTableCell:(XYTableCell*)xyTableCell onTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

/**
  Below method returns a proper content frame size of given table view
  tableView should be set before call any of these methods
 */
-(CGRect)tableViewContentViewFrame;
-(CGRect)tableViewContentViewFrameWithHeight:(CGFloat)height;
-(CGRect)tableViewContentViewFrame:(CGRect) f;

@end

