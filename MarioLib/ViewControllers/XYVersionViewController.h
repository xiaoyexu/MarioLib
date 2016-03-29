//
//  XYVersionViewController.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 2/27/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYUtility.h"
#import "XYUIDesign.h"
#import <MessageUI/MessageUI.h>
#import "XYBaseUIViewController.h"
//#import "XYCreateITDirectTicketViewController.h"

@interface XYUIVersionTextView : UITextView

@end

@interface XYVersionViewController : XYBaseUIViewController<MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) NSString* appName;
@property(nonatomic, strong) NSString* appVersion;
@property(nonatomic, strong) NSString* appTeamTitle;
@property(nonatomic, strong) NSString* appTeam;
@property(nonatomic, strong) NSString* shareEmailTitle;
@property(nonatomic) UIDataDetectorTypes appTeamDataDetectorTypes;
@property(nonatomic, strong) NSString* shareEmailBody;
@property(nonatomic) BOOL shareEmailBodyIsHTML;
@end
