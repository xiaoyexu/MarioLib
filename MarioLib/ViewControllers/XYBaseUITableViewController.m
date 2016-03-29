//
//  XYBaseUITableViewController.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseUITableViewController.h"
#import "XYBaseUITableViewDelegate.h"

@interface XYBaseUITableViewController ()
{
@protected
    UIPopoverController* _popOverController;
}
@end

@implementation XYBaseUITableViewController
{
    XYUIAlertView2* customizedAlertView;
    UIView* navigationBottomLine;
    XYUIStatusUpdater* updater;
    BOOL isStatusUpdaterEnabled;
    BOOL isNavigationAnimationInProcess;
}
@synthesize alertView;
@synthesize activityIndicator;
@synthesize busyProcessTitle;
@synthesize showActivityIndicatorView;
@synthesize xyTableViewStyle = _xyTableViewStyle;
@synthesize tableDelegate = _tableDelegate;
@synthesize useEmbededTableViewDelegate = _useEmbededTableViewDelegate;
@synthesize popOverController = _popOverController;
@synthesize refreshControlEnabled = _refreshControlEnabled;
@synthesize refreshControlTitle = _refreshControlTitle;
@synthesize helpView = _helpView;

/*
  Initialize table view controller, creating tableview delegate
 */
- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        _tableDelegate = [XYBaseUITableViewDelegate new];
        _tableDelegate.controller = self;
        _tableDelegate.tableView = self.tableView;
        self.tableView.dataSource = _tableDelegate;
        self.tableView.delegate = _tableDelegate;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

/*
  Initizlie table view controller, creating tableview delegate and container
 */
-(id)initWithStyle:(UITableViewStyle)style andTableContainer:(XYTableContainer*)container xyStyle:(XYUITableViewStyle) xyStyle cellStyle:(UITableViewCellStyle)cellStyle andTitle:(NSString *)title{
    self = [super initWithStyle:style];
    if (self) {
        _tableDelegate = [[XYBaseUITableViewDelegate alloc] initWithTableContainer:container];
        _tableDelegate.cellStyle = cellStyle;
        self.xyTableViewStyle = xyStyle;
        _tableDelegate.controller = self;
        _tableDelegate.tableView = self.tableView;
        self.tableView.dataSource = _tableDelegate;
        self.tableView.delegate = _tableDelegate;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.navigationItem.title = title;
        [XYUtility setTitle:self.navigationItem.title inNavigationItem:self.navigationItem];
    }
    return self;
}

-(void)setUseEmbededTableViewDelegate:(BOOL)useEmbededTableViewDelegate{
    _useEmbededTableViewDelegate = useEmbededTableViewDelegate;
    if (useEmbededTableViewDelegate) {
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.allowsSelectionDuringEditing = YES;
        
        if (_tableDelegate == nil) {
            _tableDelegate = [XYBaseUITableViewDelegate new];
        }
        _tableDelegate.controller = self;
        _tableDelegate.tableView = self.tableView;
        self.tableView.dataSource = _tableDelegate;
        self.tableView.delegate = _tableDelegate;
    } else {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        if (self.navigationController != nil) {
            self.navigationController.navigationBar.translucent = NO;
        }
    }
    
    //Set title label (Welter Design)
    [XYUtility setTitle:self.navigationItem.title inNavigationItem:self.navigationItem];
    
    self.navigationController.navigationBar.barStyle = [XYSkinManager instance].navigationBarBarStyle;
    
    
    // Skin Setting
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        
        self.navigationController.navigationBar.barTintColor = [XYSkinManager instance].navigationBarBarTintColor;
        
        [self.navigationController.navigationBar setTintColor:[XYSkinManager instance].navigationBarTintColor];
        
        UIColor* navigationBarBottomLineColor = [XYSkinManager instance].navigationBarBottomLineColor;
        
        if (navigationBarBottomLineColor != nil) {
            CGRect f = CGRectZero;
            f.size = self.navigationController.navigationBar.bounds.size;
            f.origin.y = f.size.height - 3;
            f.size.height = 3;
            
            if (navigationBottomLine == nil) {
                navigationBottomLine = [[UIView alloc] initWithFrame:f];
                navigationBottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
                navigationBottomLine.backgroundColor = navigationBarBottomLineColor;
                [self.navigationController.navigationBar addSubview:navigationBottomLine];
            }
            
        }
    }
    
    // Table view content adjustment for iOS above 7.0
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0 && self.tableView.style == UITableViewStyleGrouped) {
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
    
    // Set background color, also on iPad
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
    }
    
    self.useEmbededTableViewDelegate = YES;
    
    //_tableDelegate.isXYFieldsEnabled = YES;
    self.showActivityIndicatorView = YES;
    //self.xyTableViewStyle = XYUITableViewStyleReadonly;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = [XYSkinManager instance].navigationBarBarStyle;
    if (_popOverController != nil) {
        CGSize s = _popOverController.popoverContentSize;
        if (self.navigationController != nil) {
//            s.height -= 37;
            s.height -= 50;
        }
        self.contentSizeForViewInPopover = s;
    }
    [self.tableView reloadData];
}

/*
  Get XYTableCell by name
 */
-(XYTableCell*)tableCellByName:(NSString*)name{
    return [self.tableDelegate.container xyTableCellByName:name];
}

/*
  Method to set XYTableViewStyle - Not used currently
 */
-(void)setXyTableViewStyle:(XYUITableViewStyle)xyTableViewStyle{
    _xyTableViewStyle = xyTableViewStyle;
}

/*
  For edit/done button. Not used currently
 */
-(void)onEditDone:(id)sender {
    if (self.tableView.isEditing == YES) {
        [super setEditing:NO animated:YES];
        //[self.navigationController setEditing:NO animated:YES];
    } else {
        [super setEditing:YES animated:YES];
        //[self.navigationController setEditing:YES animated:YES];
        
    }
    [self.tableView reloadData];
}

/*
  Method for back to previous controller and clean all previous fields
 */
-(void)backToPreviousViewControllerAndClearFields:(BOOL)clearFields{
    if (self.navigationController.viewControllers.count <= 1) {
        return;
    }
    UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    if (clearFields && [vc conformsToProtocol:@protocol(XYBaseUITableViewMethods)]) {
        [(id<XYBaseUITableViewMethods>)vc clearFields];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
  Method for back to a certain view controller and clean fields
 */
-(void)backToViewController:(UIViewController *)viewContrller clearFields:(BOOL)clearFields{
    if ([viewContrller conformsToProtocol:@protocol(XYBaseUITableViewMethods)]) {
        [(id<XYBaseUITableViewMethods>)viewContrller clearFields];
    }
    [self.navigationController popToViewController:viewContrller animated:YES];
}

-(void)backAction{
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
  Method to shown alert view.
  Overwrite this method to give another solution for "busy process" indicator
 */
-(void)turnOnBusyFlag{
    // Creat alert view and display
    [self.view.superview bringSubviewToFront:self.view];
    if (self.showActivityIndicatorView == YES) {
        if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
            // Below iOS 7.0
            self.alertView = [[XYUIAlertView alloc] initWithTitle:self.busyProcessTitle message:@" " delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            if (self.busyProcessTitle == nil || [self.busyProcessTitle isEqualToString:@""]) {
                self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 18, 30, 30)];
            } else {
                self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 42, 30, 30)];
            }
            
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [self.alertView addSubview:self.activityIndicator];
            [self.alertView bringSubviewToFront:self.activityIndicator];
            [self.activityIndicator startAnimating];
            [self.alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        } else {
            // Above iOS 7.0
            switch ([XYSkinManager instance].xyAlertViewStyle) {
                case XYAlertViewStyleDefault:{
                    self.alertView = [[XYUIAlertView alloc] initWithTitle:self.busyProcessTitle message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                    [self.alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                }
                    
                    break;
                case XYAlertViewStyleUI5Standard:{
                    customizedAlertView = [[XYUIAlertView2 alloc] initWithTitle:self.busyProcessTitle message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    if (isStatusUpdaterEnabled) {
                        updater = [[XYUIStatusUpdater alloc] initWithDelegate:customizedAlertView];
                        customizedAlertView.alertViewStyle = XYUIAlertViewProgressIndicator;
                    }
                    [customizedAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                }
                    break;
                case XYAlertViewStyleUI5Light:{
                    customizedAlertView = [[XYUIAlertView2 alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    if (isStatusUpdaterEnabled) {
                        updater = [[XYUIStatusUpdater alloc] initWithDelegate:customizedAlertView];
                        customizedAlertView.alertViewStyle = XYUIAlertViewProgressIndicator;
                    }
                    [customizedAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                }
                    break;
                default:
                    break;
            }
        }
    }
    // Disable all interaction
    self.view.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

/*
  Method to remove alert view
  Overwrite this method to give corresponding "busy process off" indicator
 */
-(void)turnOffBusyFlag{
    // Dismiss the alert view
    if (self.showActivityIndicatorView == YES) {
        if (self.activityIndicator != nil) {
            [self.activityIndicator stopAnimating];
        }
        switch ([XYSkinManager instance].xyAlertViewStyle) {
            case XYAlertViewStyleDefault:{
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
            }
                break;
            case XYAlertViewStyleUI5Standard:{
                [customizedAlertView dismissWithClickedButtonIndex:0 animated:NO];
            }
                break;
            case XYAlertViewStyleUI5Light:{
                [customizedAlertView dismissWithClickedButtonIndex:0 animated:NO];
            }
                break;
            default:
                break;
        }
    }
    // Enable interaction
    self.view.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

/*
  Method to handle correct response.
  Do not overwrite it in subclasses, use handleCorrectResponse: instead
 */
-(void)handleNormalCorrectResponse:(XYProcessResult*) result{
    [self turnOffBusyFlag];
    [self handleCorrectResponse:result];
}

/*
  Method to handle error response
  Do not overwrite it in subclasses, use handleErrorResponse: instead
 */
-(void)handleNormalErrorResponse:(XYProcessResult*) result{
    [self turnOffBusyFlag];
    [self handleErrorResponse:result];
}

/*
  Customizing method for correct response returned
 */
-(void)handleCorrectResponse:(XYProcessResult*) result{
}

/*
  Customizing method for error response returned
 */
-(void)handleErrorResponse:(XYProcessResult*) result{
    // Params contains a "error" key string for any error message
    // By default show the error info
    NSString* error = [result.params objectForKey:@"error"];
    XYUIAlertView* alert = [[XYUIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

/*
  Method of executing a callback block in background
 */
-(void)performBusyProcessInBackground:(XYProcessResult*(^)(void))block{
    if (block == nil) {
        return;
    }
    
    XYProcessResult* (^progressBlock)() = block;
    XYProcessResult* processResult;
    @try {
        processResult = progressBlock();
        if (processResult == nil) {
            // If no process result return, end immediately
            [self performSelectorOnMainThread:@selector(turnOffBusyFlag) withObject:nil waitUntilDone:YES];
            return;
        }
        if (processResult.success == YES) {
            // For success result, call handleNormalCorrectResponse:
            [self performSelectorOnMainThread:@selector(handleNormalCorrectResponse:) withObject:processResult waitUntilDone:NO];
        } else {
            // For error result, call handleNormalErrorResponse:
            [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
        }
    }
    @catch (NSException *exception) {
        // Populating any exception reason into dictionary with key "error" and call handleNormalErrorResponse:
        NSString* errorStr;
        errorStr = exception.reason;
        if (processResult == nil) {
            processResult = [XYProcessResult new];
        }
        [processResult.params setValue:errorStr forKey:@"error"];
        [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
    }
}

/**
 Method of executing a callback block with updater in background
 */
-(void)performBusyProcessWithUpdaterInBackground:(XYProcessResult*(^)(XYUIStatusUpdater* updater))block{
    if (block == nil) {
        return;
    }
    XYProcessResult* (^progressBlock)(XYUIStatusUpdater* updater) = block;
    XYProcessResult* processResult;
    @try {
        processResult = progressBlock(updater);
        if (processResult == nil) {
            // If no process result return, end immediately
            [self performSelectorOnMainThread:@selector(turnOffBusyFlag) withObject:nil waitUntilDone:YES];
            return;
        }
        if (processResult.success == YES) {
            // For success result, call handleNormalCorrectResponse:
            [self performSelectorOnMainThread:@selector(handleNormalCorrectResponse:) withObject:processResult waitUntilDone:NO];
        } else {
            // For error result, call handleNormalErrorResponse:
            [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
        }
    }
    @catch (NSException *exception) {
        // Populating any exception reason into dictionary with key "error" and call handleNormalErrorResponse:
        NSString* errorStr;
        errorStr = exception.reason;
        if (processResult == nil) {
            processResult = [XYProcessResult new];
        }
        [processResult.params setValue:errorStr forKey:@"error"];
        [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
    }
}

/*
  Method of executing a callback block
 */
-(void)performBusyProcess:(XYProcessResult*(^)(void))block{
    if (showActivityIndicatorView == YES) {
        isStatusUpdaterEnabled = NO;
        [self turnOnBusyFlag];
    }
    [NSThread detachNewThreadSelector:@selector(performBusyProcessInBackground:) toTarget:self withObject:block];
}

/**
 Method of executing a callback with status updater
 */
-(void)performBusyProcessWithUpdater:(XYProcessResult*(^)(XYUIStatusUpdater* updater))block{
    if (showActivityIndicatorView == YES) {
        isStatusUpdaterEnabled = YES;
        [self turnOnBusyFlag];
    }
    [NSThread detachNewThreadSelector:@selector(performBusyProcessWithUpdaterInBackground:) toTarget:self withObject:block];
}

/*
  Method of executing a callback selector
 */
-(void)performBusyProcessSEL:(SEL) selector ofTarget:(id)target withObject:(id)obj{
    if (showActivityIndicatorView == YES) {
        [self turnOnBusyFlag];
    }
    NSValue *selectorValue = [NSValue valueWithBytes:&selector objCType:@encode(SEL)];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:selectorValue, @"sv",target, @"tg", obj, @"obj", nil];
    [NSThread detachNewThreadSelector:@selector(performBusyProcessSELInBackground:) toTarget:self withObject:parameters];
}

/*
  Method of executing a callback selector in background
 */
-(void)performBusyProcessSELInBackground:(NSDictionary*)p{
    // Get the selector address
    SEL selector = ((NSValue*)[p objectForKey:@"sv"]).pointerValue;
    NSString* selectorName = [NSString stringWithUTF8String:sel_getName(selector)] ;
    id obj = (id)[p objectForKey:@"tg"];
    id objects = (id)[p objectForKey:@"obj"];
    if (selector == nil) {
        return;
    }
    if (![obj respondsToSelector:selector]) {
        return;
    }
    
    XYProcessResult* processResult;
    
    @try {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        processResult = (XYProcessResult*)[obj performSelector:selector withObject:objects];
#pragma clang diagnostic pop        
        [processResult.params setValue:selectorName forKey:@"_selector_"];
        if (processResult == nil) {
            // If no process result, end immediately
            [self performSelectorOnMainThread:@selector(turnOffBusyFlag) withObject:nil waitUntilDone:YES];
            return;
        }
        if (processResult.success == YES) {
            // For success result, call handleNormalCorrectResponse:
            [self performSelectorOnMainThread:@selector(handleNormalCorrectResponse:) withObject:processResult waitUntilDone:NO];
        } else {
            // For error result, call handleNormalErrorResponse:
            [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
        }
    }
    @catch (NSException *exception) {
        // Populating any exception reason into dictionary with key "error" and call handleNormalErrorResponse:
        NSString* errorStr;
        errorStr = exception.reason;
        if (processResult == nil) {
            processResult = [XYProcessResult new];
        }
        [processResult.params setValue:errorStr forKey:@"error"];
        [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onSelectXYTableCell:(XYTableCell *)field atIndexPath:(NSIndexPath *)indexPath{
    if ([field.name isEqualToString:@"_loadMore_"]) {
        return;
    }
}

-(void)onCommitEditingStyle:(UITableViewCellEditingStyle)editingStyle forXYTableCell:(XYTableCell *)field{
}

-(void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
}

-(void)customizedTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forXYTableCell:(XYTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)moveCell:(XYTableCell *)srcCell atIndexPath:(NSIndexPath *)sourceIndexPath to:(XYTableCell *)destCell atIndexPath:(NSIndexPath *)destinationIndexPath{
}

-(UITableViewCell*)customizedTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(void)clearFields{
}

-(void)loadMoreData{
}

/*
 Method used for split view controller. For ipad version
 Show/Push view controller on detail screen(right side) given that the split view controller is XYBaseSplitViewController
 */
-(void)presentViewControllerOnSplitDetailView:(UIViewController *)vc{
    UISplitViewController* svc = self.splitViewController;
    if ([svc isKindOfClass:[XYBaseSplitViewController class]]) {
        XYBaseSplitViewController* bsvc = (XYBaseSplitViewController*)svc;
        UIViewController* detailVC = [bsvc detailViewController];
        if ([detailVC isKindOfClass:[UINavigationController class]]) {
            if (!isNavigationAnimationInProcess) {
                isNavigationAnimationInProcess = YES;
                [((UINavigationController*)detailVC)  popToRootViewControllerAnimated:NO];
                [((UINavigationController*)detailVC) pushViewController:vc animated:YES];
                // Sleep 0.7 second to avoid transition error
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSThread sleepForTimeInterval:0.7f];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        isNavigationAnimationInProcess = NO;
                    });
                });
            }
        } else {
            [bsvc setDetailViewController:vc];
        }
    }
}

/*
 Method used for split view controller. For ipad version
 Show/Push view controller on detail screen(right side) given that the split view controller is XYBaseSplitViewController
 */
-(void)performSegueWithIdentifierOnSplitDetailView:(NSString *)identifier sender:(id)sender{
    UISplitViewController* svc = self.splitViewController;
    if (![svc isKindOfClass:[XYBaseSplitViewController class]]) {
        return;
    }
    
    UIViewController* dv = [((XYBaseSplitViewController*)self.splitViewController) detailViewController];
    if ([dv isKindOfClass:[UINavigationController class]] && !isNavigationAnimationInProcess) {
        isNavigationAnimationInProcess = YES;
        [((UINavigationController*)dv) popToRootViewControllerAnimated:NO];
        UIViewController* v = [((UINavigationController*)dv) topViewController];
        [v performSegueWithIdentifier:identifier sender:sender];
        // Sleep 0.7 second to avoid transition error
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:0.7f];
            dispatch_async(dispatch_get_main_queue(), ^{
                isNavigationAnimationInProcess = NO;
            });
        });
    }
}

-(void)performSegueWithIdentifierOnSplitDetailViewIfPossible:(NSString *)identifier sender:(id)sender{
    if (self.splitViewController == nil) {
        [super performSegueWithIdentifier:identifier sender:sender];
    } else {
        [self performSegueWithIdentifierOnSplitDetailView:identifier sender:sender];
    }
}

-(void)customizedScrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

-(void)customizedScrollViewDidScroll:(UIScrollView *)scrollView{
}

-(CGFloat)customizedTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

-(void)topViewEventTriggered{
}

-(void)bottomViewEventTriggered{
}

-(UITableViewCell*)customizedCell:(XYTableCell *)xyTableCell uiTableViewCell:(UITableViewCell *)cell tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(void)onAccessoryButtonTapped:(XYTableCell *)xyTableCell onTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(void)setRefreshControlEnabled:(BOOL)refreshControlEnabled{
    _refreshControlEnabled = refreshControlEnabled;
    if ([UIDevice currentDevice].systemVersion.integerValue < 6.0) {
        self.tableDelegate.topViewEnabled = YES;
    } else {
        if (_refreshControlEnabled) {
            self.refreshControl = [UIRefreshControl new];
            [self.view addSubview:self.refreshControl];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
            [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged) forControlEvents:UIControlEventValueChanged];
        } else {
            [self.refreshControl removeFromSuperview];
            self.refreshControl = nil;
        }
    }
}

-(BOOL)refreshControlEnabled{
    return _refreshControlEnabled;
}

-(void)refreshControlValueChanged{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self topViewEventTriggered];
        dispatch_async(dispatch_get_main_queue(), ^{
                if (self.refreshControlEnabled && [UIDevice currentDevice].systemVersion.integerValue >= 6.0) {
                    [self.refreshControl endRefreshing];
                }
        });
    });
}

-(void)setRefreshControlTitle:(NSString *)refreshControlTitle{
    _refreshControlTitle = refreshControlTitle;
    
    if ([UIDevice currentDevice].systemVersion.integerValue < 6.0) {
        
    } else {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:_refreshControlTitle];
    }
    
}

-(NSString*)refreshControlTitle{
    return _refreshControlTitle;
}

-(void)showOnScreenHelpView{
    if (_helpView.superview == nil) {
        [_helpView removeFromSuperview];
        _helpView = [self returnHelpView];
        [[XYUtility mainWindowView] addSubview:_helpView];
        self.view.userInteractionEnabled = NO;
    } else {
        [_helpView removeFromSuperview];
        self.view.userInteractionEnabled = YES;
    }
}

-(UIView*)returnHelpView{
    UIView* helpView = [[UIView alloc] initWithFrame:[XYUtility mainWindowView].bounds];
    helpView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    helpView.opaque = YES;
    //    helpView.alpha = 0.3;
    helpView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIButton* exitBtn = [[UIButton alloc] initWithFrame:CGRectMake((helpView.frame.size.width - 100)/2, helpView.frame.size.height - 60, 100, 40)];
    [exitBtn setTitle:@"Exit" forState:UIControlStateNormal];
    exitBtn.backgroundColor = [XYUtility sapBlueColor];
    exitBtn.layer.borderColor = [XYUtility sapBlueColor].CGColor;
    exitBtn.layer.borderWidth = 1.0;
    exitBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [helpView addSubview:exitBtn];
    [exitBtn addTarget:self action:@selector(showOnScreenHelpView) forControlEvents:UIControlEventTouchDown];
    return helpView;
}
@end
