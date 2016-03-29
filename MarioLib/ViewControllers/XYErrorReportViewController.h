//
//  XYErrorReportViewController.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 11/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseUITableViewController.h"
#import <MessageUI/MessageUI.h>
//#import <MDF/MDF.h>
#import "XYUIDesign.h"

@interface XYErrorReportViewController : XYBaseUITableViewController <MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) NSArray* mailToRecipients;
@property(nonatomic, readonly) BOOL runLoopIndicator;
-(id)initWithUsedAsRoot:(BOOL)root;
-(void)sendReport;
@end
