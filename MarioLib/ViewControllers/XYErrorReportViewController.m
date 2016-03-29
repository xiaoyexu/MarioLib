//
//  XYErrorReportViewController.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 11/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYErrorReportViewController.h"

@interface XYErrorReportViewController ()

@end

@implementation XYErrorReportViewController
{
    BOOL _usedAsRoot;
    XYTableCell* sendReportBtn;
    XYTableCell* cleanReportBtn;
    XYTableCell* refreshReportBtn;
}
@synthesize mailToRecipients = _mailToRecipients;
@synthesize runLoopIndicator = _runLoopIndicator;
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithUsedAsRoot:(BOOL)root{
    if (self = [super init]) {
        _usedAsRoot = root;
        _runLoopIndicator = YES;
        if (_usedAsRoot) {
            UIBarButtonItem* exitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(exitView)];
            self.navigationItem.leftBarButtonItem = exitBtn;
        }
    }
    return self;
}

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
	
    [XYUtility setTitle:@"Error log" inNavigationItem:self.navigationItem];
    
    UIBarButtonItem* emailBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendReport)];
    
    UIBarButtonItem* cleanBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(cleanReport)];
    
    UIBarButtonItem* refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshReport)];


    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:emailBtn,refreshBtn,cleanBtn, nil];
  
    sendReportBtn = [XYTableCellFactory cellOfClearButton:@"sendReport" label:@"Send Report"];
    cleanReportBtn = [XYTableCellFactory cellOfClearButton:@"cleanReport" label:@"Clean Report"];
    refreshReportBtn = [XYTableCellFactory cellOfClearButton:@"refreshReport" label:@"Refresh Report"];
  
    _mailToRecipients = [NSArray arrayWithObject:@"xiaoye.xu@sap.com"];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadErrorData];
}

-(void)loadErrorData{
    [self.tableDelegate.container removeAllSections];
    
    if (self.navigationController == nil) {
        [self.tableDelegate.container removeAllHeaderSections];
        [self.tableDelegate.container addXYTableCell:sendReportBtn Level:XYViewLevelHeader section:0 row:0];
        [self.tableDelegate.container addXYTableCell:cleanReportBtn    Level:XYViewLevelHeader section:0 row:1];
        [self.tableDelegate.container addXYTableCell:refreshReportBtn Level:XYViewLevelHeader section:0 row:2];
    }
    
    for (XYErrorInfo* ei in [[XYBaseErrorCenter instance] errorList]) {
        XYTableCell* t = [XYTableCellFactory cellOfTextViewFieldUnfixed:@"t" label:@"" ratio:0 placeHolder:@"" keyboardType:UIKeyboardTypeDefault];
        t.field.value = [NSString stringWithFormat:@"[%@](%d) <%@>\n {%@}\n",ei.timestamp,ei.level, ei.title,ei.detail];
        [self.tableDelegate.container addXYTableCell:t Level:XYViewLevelWorkArea section:0 row:0];
    }
    [self.tableView reloadData];
}

-(void)onSelectXYTableCell:(XYTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([cell.name isEqualToString:@"sendReport"]) {
        [self sendReport];
    } else if ([cell.name isEqualToString:@"cleanReport"]){
        [self cleanReport];
    } else if ([cell.name isEqualToString:@"refreshReport"]){
        [self refreshReport];
    }
}

-(void)refreshReport{
    [self loadErrorData];
}

-(void)cleanReport{
    [[XYBaseErrorCenter instance] cleanAll];
    [self loadErrorData];
}

-(void)sendReport{
    MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
//    NSString* title = @"";
    
//    id delegator = [UIApplication sharedApplication].delegate;
    
//    if ([delegator isKindOfClass:[XYBaseAppDelegate class]]) {
//        MDFApp* app = ((XYBaseAppDelegate*)delegator).currentMDFApp;
//        title = [NSString stringWithFormat:@"%@ %@",app.name, app.version];
//    } else {
//        NSDictionary* dic = [NSBundle mainBundle].infoDictionary;
//        NSString* appName = [dic objectForKey:@"CFBundleIdentifier"];
//        NSString* version = [dic objectForKey:@"CFBundleVersion"];
//        title = [NSString stringWithFormat:@"%@ %@",appName, version];
//    }
    
//    [mc setSubject:title];
//    
//    NSString* body = @"Application Error, please check attached file";
//    
//    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
//    NSString* systemModel = [[UIDevice currentDevice] model];
//    NSDictionary *dic    =  [[NSBundle mainBundle] infoDictionary];
//    NSString *appName  =   [dic objectForKey:@"CFBundleIdentifier"];
//    NSString *appVersion   =  [dic valueForKey:@"CFBundleVersion"];
//   
//    NSString* deviceInfo = [NSString stringWithFormat:
//                            @"\nSystem version:%@\nSystem model:%@\nApplication name:%@\nApplication version:%@",systemVersion,systemModel,appName,appVersion];
//    body = [body stringByAppendingString:deviceInfo];
//    
//    [mc setMessageBody:body isHTML:NO];
//    [mc addAttachmentData:[[XYBaseErrorCenter instance] errorListData] mimeType:@"text/plain" fileName:@"Error.txt"];
//    [mc setToRecipients:_mailToRecipients];
    
    [self presentViewController:mc animated:YES completion:nil];
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

-(void)exitView{
    _runLoopIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
