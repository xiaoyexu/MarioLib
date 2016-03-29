//
//  SALBaseUITableViewMethods.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYTableCell.h"
#import "XYLoadMore.h"

/**
 Protocal for general table view methods
 */
@protocol XYBaseUITableViewMethods <NSObject, XYLoadMore>

@required
/**
  Method for a SALTableCell selected
 */
-(void)onSelectXYTableCell:(XYTableCell*)cell atIndexPath:(NSIndexPath*)indexPath;

/**
  Method for commiting editing style
 */
-(void)customizedTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forXYTableCell:(XYTableCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
  Method for SALTableCell moved
 */
-(void)moveCell:(XYTableCell*) srcCell atIndexPath:(NSIndexPath *)sourceIndexPath to:(XYTableCell*) destCell atIndexPath:(NSIndexPath *)destinationIndexPath;

/**
  Method for clear all SALFields
 */
-(void)clearFields;

/**
  Method for back to previous controller and clean all previous fields
  E.g. back to search view and reset search criteria
 */
-(void)backToPreviousViewControllerAndClearFields:(BOOL)clearFields;

/**
  Method for back to a certain view controller and clean fields
 */
-(void)backToViewController:(UIViewController*) viewContrller clearFields:(BOOL)clearFields;

/**
  Method for customizing UITableViewCell
  For subclass overwrite this method if SALTableCell.customizedCellForRow is YES
 */
-(UITableViewCell *)customizedCell:(XYTableCell*) xyTableCell uiTableViewCell:(UITableViewCell*) cell tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
  Method for accessory button tapped in SALTableCell
 */
-(void)onAccessoryButtonTapped:(XYTableCell*)salTableCell onTableView:(UITableView*) tableView atIndexPath:(NSIndexPath*) indexPath;

/**
  Method for present view controller on split detail view
 */
-(void)presentViewControllerOnSplitDetailView:(UIViewController*)vc;

/**
  Method for perform segue on split detail view
 */
-(void)performSegueWithIdentifierOnSplitDetailView:(NSString *)identifier sender:(id)sender;

/**
  Method for scrolling view will begin dragging
 */
-(void)customizedScrollViewWillBeginDragging:(UIScrollView *)scrollView;

/**
  Method for scolling view did scroll
 */
-(void)customizedScrollViewDidScroll:(UIScrollView *)scrollView;

/**
  Mthod for customized height of each SALTableCell
  Overwrite this method if SALDummyTableCell or SALTableCell.customizedCellForRow is YES
 */
-(CGFloat)customizedTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


//-(NSArray *)customizedSectionIndexTitlesForTableView:(UITableView *)tableView;
//
//-(NSInteger)customizedTableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
/**
  Method for top view event
 */
-(void)topViewEventTriggered;

/**
  Method for bottom view event
 */
-(void)bottomViewEventTriggered;

@end

