//
//  XYBaseAppDelegate.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 6/25/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYWelcomeViewController.h"
#import "XYSkinManager.h"
#import "XYUIDesign.h"
////#import <MDF/MDF.h>
//#import "XYUIAlertView.h"
////#import "XYFavoriteCustomerItem.h"
////#import "XYBPAccountSearchEngine.h"
//#import "XYBaseErrorCenter.h"
#import "XYErrorReportViewController.h"
#import "XYVersionViewController.h"
#import "XYSkinManager.h"

////#import "XYLoginContext.h"
////#import "XYAPNSManager.h"

/**
 This class is a base impelementation of UIApplicationDelegate
 To use it make sure MDF framework is added
 */
@interface XYBaseAppDelegate : UIResponder <UIApplicationDelegate,XYWelcomeViewDelegate>
{
//@protected
//    NSURL* currentAppLink;
}
@property (strong, nonatomic) UIWindow *window;
//@property (strong, readonly) XYGatewayConnector* mdfConnector;
/**
 Return MDFApp object of current app
 */
//-(MDFApp*)currentMDFApp;


/**
 Return postbox server URL
 By default return nil, server connected will base on dev or release version of MDF
 The method will be called after preMDFInitializing but before MDFFramework initialized
 */
//-(NSURL*)currentBackendServerURL;

/**
 Return current MDFAccess type
 By default it return MDFAccessExtern
 */
//-(MDFAccess)currentMDFAccess;
/**
 Return debug profile store value here
 The method will be called before intializing framework
 E.g. @"<your password>"
 */
//-(NSString*)debugProfilePassPhrase;

/**
 Return allowed MDF authentication array.
 E.g. [NSNumber numberWithInt:MDFAuthenticationIdentity]
      [NSNumber numberWithInt:MDFAuthenticationUsername]
 By default return nil and MDFAuthenticationIdentity will be used
 */
//-(NSArray*)allowedAuthentications;

/**
 Return welcome view controller
 To dismiss welcome view controller, send notification XYWelcomeViewControllerDismissNotification
 E.g.
 [[NSNotificationCenter defaultCenter] postNotificationName:XYWelcomeViewControllerDismissNotification object:nil];
 */
-(UIViewController*)appWelcomeViewController;

/**
 Return version info view controller
 If Return nil, by default using MDF FrontViewController
 Otherwise return customized version controller.
 For any change, please use follow example:
 
 XYVersionViewController* vvc = [XYVersionViewController new];
 vvc.appName = @"App name";
 vvc.appVersion = @"App version";
 vvc.appTeamTitle = @"by AGS Service & Support Infrastructure";
 vvc.appTeam = @"Test http://www.sap.com 012-1234567890";
 vvc.appTeamDataDetectorTypes = UIDataDetectorTypeAll;
 vvc.shareEmailTitle = @"Title of sharing email";
 vvc.shareEmailBody = @"Body of sharing email";
 vvc.shareEmailBodyIsHTML = NO;
 UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vvc];
 return nav;
 */
-(UIViewController*)appVersionViewController;

/**
 Return whether welcome view controller need display
 */
-(BOOL)isWelcomeViewControllerNeedDisplay;

/**
 Animation options for welcome view controller to disappear
 */
-(UIViewAnimationOptions)welcomeViewControllerWillDisappearAnimationOptions;

/**
 Anything need to do before MDF framework initialized
 */
-(void)preAppInitializing;

/**
 Logic for app initializing
 */
-(BOOL)standardAppInitializingWithJumped:(BOOL) isJumped andParameter:(NSDictionary*) parameter;

/**
 Anything need to do after MDF framework initialized
 */
-(void)postAppInitializing;

/**
 To update customer data for backward compatibility
 XYBPSearchModeCRMICSystem mode is used for BP Search
 The method should be called after "_gateway" service initialized
 @param customers NSArray of XYFavoriteCustomerItem
 
 Example.
 NSArray* customerList = [XYStorageManager readArrayDataOfClass:[XYFavoriteCustomerItem class] byName:favCust];
 
 customerList = [self updateCustomerData:customerList];
 
 */
//-(NSArray*)updateCustomerData:(NSArray*)customers;

/**
  For any uncaughtexception, show report email view
 */
-(void)showErrorReport;

/**
  Return whether the report email view is displaying
 */
-(BOOL)isErrorReportDisplayed;

/**
 Do any skin setting with XYSkinManager
 By default it reads from preference setting(root.plist) by key "skinStyle", the value should be a number, default SkinStyleDefault
 Notice app need to be restarted for skin changing
 */
-(XYSkinManager*)appSkinSetting:(XYSkinManager*)skinMgr;

/**
 Method for setting updates
 NSUserDefaults* s = (NSUserDefaults*)notification.object;
 */
-(void)appSettingsFromBundleRefreshed:(NSNotification*)notification;

/**
 Return application logon style, MDF or customized
 */
//-(XYLogonStyle)appLogonStyle;

/**
 If XYLogonStyleCustomized is defined, execute customized login logic below
 */
//-(void)loginWithIdentity:(SecIdentityRef)identity;

/**
 Return whether debug info been logged
 */
//-(BOOL)appLoggingDebugInfo;

// *****Push notification methods***** //
/**
 Return if push notification is enabled for this app
 If it's YES, the app will update subscription table by using XYGatewayConnector that user returned
 */
//-(BOOL)isPushNotificationEnabled;

/**
 Return the default push notification delivery address
 Only effective when isPushNotificationEnabled returns YES
 */
//-(NSString*)defaultPushNotificationDeliveryAddress;

/**
 Return the connector that SubscriptionCollection locates
 E.g. Connector with url "https://pgxmain.wdf.sap.corp/sap/opu/odata/sap/ZS_ESCALATIONS"
 */
//-(XYGatewayConnector*)pushNotificationConnector;
// *****End of push notification methods***** //
@end
