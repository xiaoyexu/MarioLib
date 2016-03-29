//
//  XYVersionViewController.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 2/27/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYVersionViewController.h"

@interface XYVersionViewController ()

@end

@implementation XYVersionViewController
{
    XYBaseUITableViewDelegate* delegate;
    UISwipeGestureRecognizer* sgr;
    UILabel* _logoDesc;
    UIImageView* _yellowBar;
    UILabel* _appNameLabel;
    UILabel* _appVersionLabel;
    UILabel* _appTeamTitleLabel;
    XYUIVersionTextView* _appTeamTextView;
    UITableView* _tableView;
}

@synthesize appName = _appName;
@synthesize appVersion = _appVersion;
@synthesize appTeamTitle = _appTeamTitle;
@synthesize appTeam = _appTeam;
@synthesize appTeamDataDetectorTypes = _appTeamdataDetectorTypes;
@synthesize shareEmailTitle = _shareEmailTitle;
@synthesize shareEmailBody = _shareEmailBody;
@synthesize shareEmailBodyIsHTML = _shareEmailBodyIsHTML;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [XYUtility setTitle:@"About" inNavigationItem:self.navigationItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    scrollView.backgroundColor = [UIColor clearColor];
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:scrollView];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
//    
//    CGRect logoRect;
//    CGRect logoDescRect;
//    CGRect yellowBarRect;
//    CGRect appNameLabelRect;
//    CGRect appVersionLabelRect;
//    CGRect appTeamTitleLabelRect;
//    CGRect appTeamTextViewRect;
//    CGRect tableViewRect;
//    
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
//        logoRect = CGRectMake(20, 10, 100, 50);
//        logoDescRect = CGRectMake(self.view.bounds.size.width - 160, 20, 200, 50);
//        yellowBarRect = CGRectMake(20, 70, self.view.bounds.size.width - 40, 5);
//        appNameLabelRect = CGRectMake(0, 80, self.view.bounds.size.width, 50);
//        appVersionLabelRect = CGRectMake(0, 110, self.view.bounds.size.width, 50);
//        appTeamTitleLabelRect = CGRectMake(0, 130, self.view.bounds.size.width, 60);
//        appTeamTextViewRect = CGRectMake(0, 175, self.view.bounds.size.width, 125);
//        tableViewRect = CGRectMake(self.view.bounds.size.width / 2.0 - 160, 300, 320, 200);
//        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width,450)];
//    } else {
//        logoRect = CGRectMake(20, 10, 100, 50);
//        logoDescRect = CGRectMake(self.view.bounds.size.width - 220, 20, 200, 50);
//        yellowBarRect = CGRectMake(20, 70, self.view.bounds.size.width - 40, 10);
//        appNameLabelRect = CGRectMake(0, 90, self.view.bounds.size.width, 60);
//        appVersionLabelRect = CGRectMake(0, 120, self.view.bounds.size.width, 60);
//        appTeamTitleLabelRect = CGRectMake(0, 150, self.view.bounds.size.width, 60);
//        appTeamTextViewRect = CGRectMake(0, 200, self.view.bounds.size.width, 350);
//        tableViewRect = CGRectMake(self.view.bounds.size.width / 2.0 - 160, appTeamTextViewRect.origin.y + appTeamTextViewRect.size.height + 10, 320, 400);
//        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width,750)];
//    }
//    
//    [scrollView addSubview:[XYUtility sapLogoWithFrame:logoRect withRMark:YES]];
//    
//    _logoDesc = [[UILabel alloc] initWithFrame:logoDescRect];
//    _logoDesc.text = @"© 2014 SAP SE";
//    _logoDesc.font = [UIFont systemFontOfSize:20];
//    _logoDesc.backgroundColor = [UIColor clearColor];
//    _logoDesc.textColor = [UIColor darkGrayColor];
//    _logoDesc.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    [scrollView addSubview:_logoDesc];
//    
//    _yellowBar = [[UIImageView alloc] initWithFrame:yellowBarRect];
//    _yellowBar.backgroundColor = [UIColor SAPGoldenButtonColor];
//    _yellowBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [scrollView addSubview:_yellowBar];
//    
//    _appNameLabel = [[UILabel alloc] initWithFrame:appNameLabelRect];
//    _appNameLabel.backgroundColor = [UIColor clearColor];
//    _appNameLabel.text = _appName;
//    _appNameLabel.font = [UIFont systemFontOfSize:22];
//    _appNameLabel.textAlignment = NSTextAlignmentCenter;
//    _appNameLabel.textColor = [UIColor darkGrayColor];
//    _appNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    _appNameLabel.adjustsFontSizeToFitWidth = YES;
//    [scrollView addSubview:_appNameLabel];
//    
//    _appVersionLabel = [[UILabel alloc] initWithFrame:appVersionLabelRect];
//    _appVersionLabel.backgroundColor = [UIColor clearColor];
//    _appVersionLabel.text = _appVersion;
//    _appVersionLabel.font = [UIFont systemFontOfSize:20];
//    _appVersionLabel.textAlignment = NSTextAlignmentCenter;
//    _appVersionLabel.textColor = [UIColor darkGrayColor];
//    _appVersionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [scrollView addSubview:_appVersionLabel];
//    
//    _appTeamTitleLabel = [[UILabel alloc] initWithFrame:appTeamTitleLabelRect];
//    _appTeamTitleLabel.backgroundColor = [UIColor clearColor];
//    _appTeamTitleLabel.text = _appTeamTitle;
//    _appTeamTitleLabel.font = [UIFont systemFontOfSize:15];
//    _appTeamTitleLabel.textAlignment = NSTextAlignmentCenter;
//    _appTeamTitleLabel.textColor = [UIColor darkGrayColor];
//    _appTeamTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    _appTeamTitleLabel.adjustsFontSizeToFitWidth = YES;
//    [scrollView addSubview:_appTeamTitleLabel];
//
//    _appTeamTextView = [[XYUIVersionTextView alloc] initWithFrame:appTeamTextViewRect];
//    _appTeamTextView.editable = NO;
//    _appTeamTextView.scrollEnabled = YES;
//    _appTeamTextView.backgroundColor = [UIColor clearColor];
//    _appTeamTextView.text = _appTeam;
//    _appTeamTextView.font = [UIFont systemFontOfSize:15];
//    _appTeamTextView.textAlignment = NSTextAlignmentCenter;
//    _appTeamTextView.textColor = [UIColor darkGrayColor];
//    _appTeamTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [_appTeamTextView setDataDetectorTypes:self.appTeamDataDetectorTypes];
//    [scrollView addSubview:_appTeamTextView];
//    
//    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStyleGrouped];
//    _tableView.backgroundView = nil;
//    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.scrollEnabled = NO;
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
//        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
//    } else {
//        _tableView.contentInset = UIEdgeInsetsZero;
//    }
//
//    delegate = [XYBaseUITableViewDelegate new];
//    delegate.controller = self;
//    delegate.tableView = _tableView;
//    _tableView.dataSource = delegate;
//    _tableView.delegate = delegate;
//    
//    [scrollView addSubview:_tableView];
//    
//    XYButtonTableCell* sendEmailButton = [XYTableCellFactory cellOfClearButton:@"sendEmail" label:@"Error/Bug report or proposal"];
//    sendEmailButton.backgroundColor = [UIColor whiteColor];
//    [delegate.container addXYTableCell:sendEmailButton Level:XYViewLevelWorkArea section:0 row:0];
//    
//    XYButtonTableCell* createITTicketButton = [XYTableCellFactory cellOfClearButton:@"createITTicket" label:@"Create IT Ticket"];
//    createITTicketButton.backgroundColor = [UIColor whiteColor];
//    [delegate.container addXYTableCell:createITTicketButton Level:XYViewLevelWorkArea section:0 row:1];
//    
//    XYButtonTableCell* shareButton = [XYTableCellFactory cellOfClearButton:@"share" label:@"Share App"];
//    shareButton.backgroundColor = [UIColor whiteColor];
//    [delegate.container addXYTableCell:shareButton Level:XYViewLevelWorkArea section:0 row:2];
//    
//    XYButtonTableCell* closeButton = [XYTableCellFactory cellOfClearButton:@"close" label:@"Close"];
//    closeButton.backgroundColor = [UIColor whiteColor];
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onSelectXYTableCell:(XYTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{

//    if ([cell.name isEqualToString:@"sendEmail"]) {
//        XYErrorReportViewController* erv = [XYErrorReportViewController new];
//        if (self.navigationController != nil) {
//            [self.navigationController pushViewController:erv animated:YES];
//        } else {
//            [self presentViewController:erv animated:YES completion:nil];
//        }
//    } else if ([cell.name isEqualToString:@"createITTicket"]){
//        XYCreateITDirectTicketViewController* createITTicketViewController = [XYCreateITDirectTicketViewController new];
//        if (self.navigationController != nil) {
//            [self.navigationController pushViewController:createITTicketViewController animated:YES];
//        } else {
//            [self presentViewController:createITTicketViewController animated:YES completion:nil];
//        }
//    } else if ([cell.name isEqualToString:@"share"]) {
//        MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
//        NSString* title = @"";
//        mc.mailComposeDelegate = self;
//        id delegator = [UIApplication sharedApplication].delegate;
//        
//        if ([XYUtility isBlank:_shareEmailTitle]) {
//            if ([delegator isKindOfClass:[XYBaseAppDelegate class]]) {
//                MDFApp* app = ((XYBaseAppDelegate*)delegator).currentMDFApp;
//                title = [NSString stringWithFormat:@"Sharing %@ %@",app.name, app.version];
//            } else {
//                NSDictionary* dic = [NSBundle mainBundle].infoDictionary;
//                NSString* appName = [dic objectForKey:@"CFBundleIdentifier"];
//                NSString* version = [dic objectForKey:@"CFBundleVersion"];
//                title = [NSString stringWithFormat:@"Sharing %@ %@",appName, version];
//            }
//            [mc setSubject:title];
//        } else {
//            [mc setSubject:_shareEmailTitle];
//        }
//        
//        if ([XYUtility isBlank:_shareEmailBody]) {
//            [mc setMessageBody:@"" isHTML:NO];
//        } else {
//            [mc setMessageBody:_shareEmailBody isHTML:_shareEmailBodyIsHTML];
//        }
//        [self presentViewController:mc animated:YES completion:nil];
//    } else if ([cell.name isEqualToString:@"close"]) {
//        [self close];
//    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:{
            
        }
            break;
        case MFMailComposeResultSaved:{
            
        }
            break;
        case MFMailComposeResultSent:{
            
        }
            break;
        case MFMailComposeResultFailed:{
            XYUIAlertView* alert = [[XYUIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send mail, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation XYUIVersionTextView

-(BOOL)canBecomeFirstResponder{
    return NO;
}

@end
