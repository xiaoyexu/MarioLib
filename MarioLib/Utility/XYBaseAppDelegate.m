//
//  XYBaseAppDelegate.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 6/25/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseAppDelegate.h"

@implementation XYBaseAppDelegate
{
    BOOL jumpedFromOtherApp;
    XYErrorReportViewController* erv;
    UIViewController* defaultRootViewController;
    BOOL _isJumped;
    NSDictionary* _parameter;
    SecIdentityRef _selectedIdentity;
//    XYGatewayConnector* _mdfConnector;
    BOOL _canCustomizedInitial;
}
@synthesize window = _window;
//@synthesize mdfConnector = _mdfConnector;

//-(MDFApp*)currentMDFApp{
//    return nil;
//}
//
//-(NSURL*)currentBackendServerURL{
//    return nil;
//}
//
//-(MDFAccess)currentMDFAccess{
//    return MDFAccessExtern;
//}
//
//-(NSString*)debugProfilePassPhrase{
//    return nil;
//}
//
//-(NSArray*)allowedAuthentications{
//    return nil;
//}

-(UIViewController*)appWelcomeViewController{
    return nil;
}

-(UIViewController*)appVersionViewController{
    // Default version controller
    XYVersionViewController* vvc = [XYVersionViewController new];
//    MDFApp* app = [self currentMDFApp];
//    vvc.appName = app.name;
//    vvc.appVersion = [NSString stringWithFormat:@"Version %@",app.version];
//    vvc.appTeamTitle = @"by AGS Service & Support Infrastructure";
//    vvc.appTeam = app.description;
//    vvc.shareEmailTitle = [NSString stringWithFormat:@"Check out the %@ solution I found on the Internal Store!",app.name];
//    NSString* appURL = [currentAppLink isKindOfClass:[NSURL class]] ? currentAppLink.absoluteString : [currentAppLink description];
//    vvc.shareEmailBody = [NSString stringWithFormat:@"Hi,<br>Check out the <a href=\"%@\">%@</a> solution I found on the Internal Store!<br><br>Regards",appURL,app.name];
//    vvc.shareEmailBodyIsHTML = YES;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vvc];
    return nav;
}

-(BOOL)isWelcomeViewControllerNeedDisplay{
    return NO;
}

-(UIViewAnimationOptions)welcomeViewControllerWillDisappearAnimationOptions{
    return UIViewAnimationOptionTransitionFlipFromBottom;
}

//-(void)preMDFInitializing{
//    
//}
//
//-(void)postMDFInitializing{
//    
//}

//-(void)mdfDefaultInstanceInitializing:(MDFFramework *)framework target:(id)target jumped:(BOOL)isJumped jumpedParameter:(NSDictionary *)parameter{
//    
//}

void uncaughtExceptionHandler(NSException* exception) {
    
    NSString* errorString = [NSString stringWithFormat:@"Reason:%@\nCallback:%@",exception.reason,exception.callStackSymbols];
    
    [[XYBaseErrorCenter instance] recordErrorWithTitle:exception.name detail:errorString level:XYErrorLevelFatal];
    
    if (![[UIApplication sharedApplication].delegate isKindOfClass:[XYBaseAppDelegate class]]) {
        return;
    }
    
    XYBaseAppDelegate* bd =(XYBaseAppDelegate*)[UIApplication sharedApplication].delegate;
    
    // Error report UI display must in main thread
    [bd performSelectorOnMainThread:@selector(showErrorReport) withObject:nil waitUntilDone:YES];

    while (bd.isErrorReportDisplayed) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

void signalHandler(int signal){
    NSString* errorString = [NSString stringWithFormat:@"Signal %d received",signal];
    [[XYBaseErrorCenter instance] recordErrorWithTitle:errorString detail:@"" level:XYErrorLevelFatal];
}

-(void)showErrorReport{
    if ([UIApplication sharedApplication].keyWindow == nil) {
        // keyWindow not available, not able to show error report view
        return;
    }
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:erv];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fatal Error" message:@"An uncaught exception raised, the application will closed soon\nPlease take chance to report the error by mail\nIn case the app stops responding, please close it manually" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

-(BOOL)isErrorReportDisplayed{
    if ([UIApplication sharedApplication].keyWindow == nil) {
        // keyWindow not available, not able to show error report view
        return NO;
    }
    return erv.runLoopIndicator;
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [XYBaseErrorCenter instance].debugMode = [self appLoggingDebugInfo];
    
    [[XYBaseErrorCenter instance] recordDebugInfo:@"didFinishLaunchingWithOptions started"];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    signal(SIGABRT, &signalHandler);
    signal(SIGILL, &signalHandler);
    signal(SIGSEGV, &signalHandler);
    signal(SIGFPE, &signalHandler);
    signal(SIGBUS, &signalHandler);
    signal(SIGPIPE, &signalHandler);
    erv = [[XYErrorReportViewController alloc] initWithUsedAsRoot:YES];
    [XYKeyboardListener instance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appSettingsFromBundleRefreshed:) name:NSUserDefaultsDidChangeNotification object:nil];
    [self appSkinSetting:[XYSkinManager instance]];
    
    // Push notification registration
    if ([self isPushNotificationEnabled]) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge) categories:nil]];
        } else {
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
        }
#else
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
#endif
        
    }
    
//    [MDFFramework parameters:launchOptions];
    if (launchOptions == nil || launchOptions.count == 0) {
        [[XYBaseErrorCenter instance] recordDebugInfo:@"launchOptions is empty, start [self appInitializingWithJumped:NO andParameter:nil]"];
        return [self appInitializingWithJumped:NO andParameter:nil];
    }
    
    [[XYBaseErrorCenter instance] recordDebugInfo:@"didFinishLaunchingWithOptions ended"];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    for (NSString* parameter in [[url query] componentsSeparatedByString:@"&"]) {
        NSArray* value = [parameter componentsSeparatedByString:@"="];
        if([value count]!=1) {
            [parameters setObject:[value objectAtIndex:1] forKey:[value objectAtIndex:0]];
        } else {
            [parameters setObject:[[NSObject alloc] init] forKey:parameter];
        }
    }
    [[XYBaseErrorCenter instance] recordDebugInfo:[NSString stringWithFormat:@"URL parameter:%@",[parameters descriptionInStringsFileFormat]]];
    return [self appInitializingWithJumped:YES andParameter:parameters];
}

-(BOOL)standardAppInitializingWithJumped:(BOOL) isJumped andParameter:(NSDictionary*) parameter{
    
    [self preAppInitializing];
    // Login logic
    
    [self postAppInitializing];
    return YES;
}

/**
 This method check and show the welcome screen
 */
-(BOOL)appInitializingWithJumped:(BOOL) isJumped andParameter:(NSDictionary*) parameter{
    
    // Check welcome view controller
    UIViewController* welcomeViewController = [self appWelcomeViewController];
    if (welcomeViewController != nil && [self isWelcomeViewControllerNeedDisplay]) {
        [[XYBaseErrorCenter instance] recordDebugInfo:@"Welcome view controller found"];
        
        // Save parameter
        _isJumped = isJumped;
        _parameter = parameter;
        
        // Add observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(welcomeViewControllerDismissed) name:XYWelcomeViewControllerDismissNotification object:nil];
        defaultRootViewController = self.window.rootViewController;
        
        // Initialize welcome view controller by add and remove to the default root view controller
        [defaultRootViewController addChildViewController:welcomeViewController];
        [welcomeViewController removeFromParentViewController];
        
        // Replace root view controller with Welcome View Controller
        self.window.rootViewController = welcomeViewController;
        return YES;
    } else {
        [[XYBaseErrorCenter instance] recordDebugInfo:@"No welcome view controller found"];
        return [self standardAppInitializingWithJumped:isJumped andParameter:parameter];
    }
}

-(void)welcomeViewControllerDismissed{
    [[XYBaseErrorCenter instance] recordDebugInfo:@"welcomeViewControllerDismissed started"];
    [UIView transitionWithView:self.window duration:0.2 options:[self welcomeViewControllerWillDisappearAnimationOptions] animations:^{
        
        // Resume root view controller
        self.window.rootViewController = defaultRootViewController;
        
        // Back to intializing process
        
        [self standardAppInitializingWithJumped:_isJumped andParameter:_parameter];
        
//        switch ([self appLogonStyle]) {
//            case XYLogonStyleMDF:{
//                // Continue MDF logon
//                [self standardMDFInitializingWithJumped:_isJumped andParameter:_parameter];
//            }
//                
//                break;
//            case XYLogonStyleCustomized:{
//                // Continue Customized logon
//                [self customizedInitializingWithJumped:_isJumped andParameter:_parameter];
//            }
//            default:
//                break;
//        }
    } completion:^(BOOL finished) {
        
    }];
    [[XYBaseErrorCenter instance] recordDebugInfo:@"welcomeViewControllerDismissed ended"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[XYBaseErrorCenter instance] recordDebugInfo:@"applicationWillResignActive started"];
    
    if (jumpedFromOtherApp) {
        [[XYBaseErrorCenter instance] recordDebugInfo:@"Set jumpedFromOtherApp to NO"];
        jumpedFromOtherApp = NO;
    }
    
    // Set flag to disconnected for customizing login
//    if ([self appLogonStyle] == XYLogonStyleCustomized) {
//        [[XYLoginContext instance] disconnect];
//    }
    [[XYBaseErrorCenter instance] recordDebugInfo:@"applicationWillResignActive ended"];
}

-(XYSkinManager*)appSkinSetting:(XYSkinManager *)skinMgr{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* skinStyle = [userDefaults objectForKey:skinStyleKey];
    XYSkinStyle style = (XYSkinStyle)skinStyle.integerValue;
    if (skinStyle == nil) {
        style = XYSkinStyleDefault;
    }
    skinMgr.style = style;
    return skinMgr;
}

-(void)appSettingsFromBundleRefreshed:(NSNotification*)notification{

}

-(XYLogonStyle)appLogonStyle{
    return XYLogonStyleMDF;
}

-(BOOL)appLoggingDebugInfo{
    return NO;
}

-(void)preAppInitializing{
    
}

-(void)postAppInitializing{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)isPushNotificationEnabled{
    return NO;
}

//-(NSString*)defaultPushNotificationDeliveryAddress{
//    return @"";
//}

//-(XYGatewayConnector*)pushNotificationConnector{
//    NSLog(@"XYBaseAppDelegate pushNotificationConnector return nil");
//    return nil;
//}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if ([identifier isEqualToString:@"declineAction"]) {
        
    } else if ([identifier isEqualToString:@"answerAction"]){
        
    }
}

-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken_in {

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
   
    NSString* msg = err.description;
    NSString* str = @"didFailToRegisterForRemoteNotificationsWithError called";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:str message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
