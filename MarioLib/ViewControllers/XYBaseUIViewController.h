//
//  XYBaseUIViewController.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBusyProcessorDelegate.h"
#import "XYBusyProcessDelegate2.h"
#import "XYBaseUITableViewMethods.h"
#import "XYProcessResult.h"
#import "XYBaseSplitViewController.h"
#import "XYUIAlertView.h"
#import "XYNotificationView.h"
#import "XYSkinManager.h"
#import "XYUIAlertView2.h"

@interface XYBaseUIViewController : UIViewController <UIAlertViewDelegate,XYBusyProcessorDelegate,XYBusyProcessDelegate2,XYBaseUITableViewMethods>
{
    @protected
    UIPopoverController* _popOverController;
    
    XYNotificationView* _notificationView;
}
// AlertView for any busy process
@property (strong, nonatomic) IBOutlet XYUIAlertView* alertView;

// Activity indicator for busy process
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

// The title of alert view
@property (strong, nonatomic) NSString* busyProcessTitle;

// The flag whether alert need to be shown
@property (nonatomic) BOOL showActivityIndicatorView;

// A reference to popover controller
@property (nonatomic,strong) UIPopoverController* popOverController;

@property (nonatomic, strong) UIView* helpView;

// Callback for any time consuming task
-(void)performBusyProcess:(XYProcessResult*(^)(void))block;

// Callback selector for any time consuming task
-(void)performBusyProcessSEL:(SEL) selector ofTarget:(id) target withObject:(id)obj;

// Perform segue on split view
-(void)performSegueWithIdentifierOnSplitDetailView:(NSString *)identifier sender:(id)sender;

// Peform segue, if split view is availble, perform on root detail view, otherwise on self
-(void)performSegueWithIdentifierOnSplitDetailViewIfPossible:(NSString *)identifier sender:(id)sender;

/*
 Display or hide on-screen help view
 */
-(void)showOnScreenHelpView;

/*
 Return helpView
 */
-(UIView*)returnHelpView;
@end

