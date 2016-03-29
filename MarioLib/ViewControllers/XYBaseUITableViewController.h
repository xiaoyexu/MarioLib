//
//  XYBaseUITableViewController.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDesighHeader.h"
#import "XYTableCell.h"
#import "XYBusyProcessDelegate2.h"
#import "XYBaseUITableViewMethods.h"
#import "XYTableContainer.h"
#import "XYExpandableTableCell.h"
#import "XYBusyProcessorDelegate.h"
#import "XYBaseSplitViewController.h"
#import "XYUIAlertView.h"
#import "XYUIAlertView2.h"
#import "XYProcessbarView.h"

@class XYBaseUITableViewDelegate;

@interface XYBaseUITableViewController : UITableViewController <UIAlertViewDelegate,XYBusyProcessorDelegate,XYBusyProcessDelegate2,XYBaseUITableViewMethods>{
    @protected
    // Table view delegate instance
    XYBaseUITableViewDelegate* _tableDelegate;
    //UIPopoverController* _popOverController;
}

// A flag whether use embeded table view delegate;
@property (nonatomic) BOOL useEmbededTableViewDelegate;

// Store XYUITableViewStyle -- Not used currently
@property (nonatomic) XYUITableViewStyle xyTableViewStyle;

// AlertView for any busy process
@property (strong, nonatomic) IBOutlet XYUIAlertView* alertView;

// Activity indicator for busy process
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

// Table view delegate instance
@property (readonly, nonatomic)XYBaseUITableViewDelegate* tableDelegate;

// A reference to popover controller
@property (nonatomic,strong) UIPopoverController* popOverController;

// Enable refresh controller
@property (nonatomic) BOOL refreshControlEnabled;

// Refresh controller title string
// Only work for iOS >= 6.0
@property (nonatomic,strong) NSString* refreshControlTitle;

@property (nonatomic, strong, readonly) UIView* helpView;

// Initialize self by containter etc
-(id)initWithStyle:(UITableViewStyle)style andTableContainer:(XYTableContainer*)container xyStyle:(XYUITableViewStyle) xyStyle cellStyle:(UITableViewCellStyle) cellStyle andTitle:(NSString *)title;

// Return XYTableCell by name
-(XYTableCell*)tableCellByName:(NSString*)name;

// Perform segue on split view
-(void)performSegueWithIdentifierOnSplitDetailView:(NSString *)identifier sender:(id)sender;

// Peform segue, if split view is availble, perform on root detail view, otherwise on self
-(void)performSegueWithIdentifierOnSplitDetailViewIfPossible:(NSString *)identifier sender:(id)sender;

// TableViewMethods
// The method will be execute in background, no need to open a new thread within it
-(void)topViewEventTriggered;

// TableViewMethods
// The method will be execute in background, no need to open a new thread within it
-(void)bottomViewEventTriggered;

/*
 Display or hide on-screen help view
 */
-(void)showOnScreenHelpView;

/*
 Return helpView
 */
-(UIView*)returnHelpView;
@end
