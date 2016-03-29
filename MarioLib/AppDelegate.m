//
//  AppDelegate.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 1/8/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "AppDelegate.h"
#import "XYConnection.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL)isWelcomeViewControllerNeedDisplay{
    return NO;
}

-(UIViewController*)appWelcomeViewController{
    XYWelcomeViewController* wc = [XYWelcomeViewController new];
    wc.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:wc action:@selector(enterAppAction)];
    [wc.view addGestureRecognizer:tgr];
    return wc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BOOL result = [super application:application didFinishLaunchingWithOptions:launchOptions];
    [UMessage startWithAppkey:@"54c5f9d1fd98c515dd000253" launchOptions:launchOptions];
    [UMessage registerRemoteNotificationAndUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge) categories:nil]];
    return result;
    
//    [self testJsonResponse];
    [UMessage startWithAppkey:@"54c59bacfd98c5c55600025c" launchOptions:launchOptions];
    
    //register remoteNotification types
    
//    register remoteNotification types (iOS 8.0以下)
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    [UMessage registerRemoteNotificationAndUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge) categories:nil]];

#else
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    #endif
    
    
    // iOS 8
    
//    [self registerPushNotification:application];
    return YES;
}


-(void)registerPushNotification:(UIApplication *)application{
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

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if ([identifier isEqualToString:@"declineAction"]) {
        
    } else if ([identifier isEqualToString:@"answerAction"]){
        
    }
}

-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken_in {
    NSString* tokenString = [[deviceToken_in description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString* deviceTokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Got token %@",deviceTokenString);
    [UMessage registerDeviceToken:deviceToken_in];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error %@",err.description);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UMessage didReceiveRemoteNotification:userInfo];
}

//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    [UMessage didReceiveRemoteNotification:userInfo];
//}

-(XYSkinManager*)appSkinSetting:(XYSkinManager *)skinMgr{
    skinMgr.style = XYSkinStyleUI5;
    skinMgr.xyAlertViewStyle = XYAlertViewStyleUI5Standard;
    return skinMgr;
}

-(BOOL)standardAppInitializingWithJumped:(BOOL) isJumped andParameter:(NSDictionary*) parameter{
    
    
    
//    [self testConnectorDictRequest];
//    [self testConnector];
    
    [self testEncrypt3];
//    [self testPost];
    
//    [self testBase64];
//    [self testGetFullStoryByMessageEngine];
//    [self testEncrypt2];
    return YES;
}


-(void)testGetFullStoryByMessageEngine{
    NSString* url = @"http://mariopython.sinaapp.com";
    //    NSString* url = @"http://192.168.1.4";
    
    //    [[XYConnectorManager instance] initConnectorWithURL:url asAlias:@"_connector"];
    //
    //    XYConnector* connector = [[XYConnectorManager instance] connectorByAlias:@"_connector"];
    
    // Connector gives url
    XYConnector* connector = [[XYConnector alloc] initWithURL:url];
    
    // Connection process detail sending
    XYConnection* connection = [XYConnection new];
    connector.connection = connection;
    
    // Message engine manage multiple connectors
    [[XYMessageEngine instance] setConnector:connector forStage:XYMessageStageDevelopment];
    
    // Message engine delegate
    [XYMessageEngine instance].delegate = self;
    
    // Register message configuration
    MessageConfig* mc = [MessageConfig new];
    mc.relativePath = @"GetFullStoryById";
    mc.httpMethod = @"POST";
    //    [[XYMessageEngine instance].messageUrlMapping setObject:mc forKey:NSStringFromClass([XYDictRequest class])];
    
    [[XYMessageEngine instance] setConfig:mc forMessage:[XYGetFullStoryRequest class]];
    
    
    [XYMessageEngine instance].runningStage = XYMessageStageDevelopment;
    
    XYGetFullStoryRequest* itemRequest = [XYGetFullStoryRequest new];
    itemRequest.storyId = [NSNumber numberWithInt:1];
    XYGetFullStoryResponse* itemResponse = (XYGetFullStoryResponse*)[[XYMessageEngine instance] send:itemRequest];
    
    for (StoryListItem* l in itemResponse.stories) {
        NSLog(@">>>>>%@ %@ %@",l.storyId, l.header, l.item);
    }
    
//    NSLog(@"%@",itemResponse);
}




-(void)testAppendStory{
    
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    
    req.requestURL = [NSURL URLWithString:@"http://mariopython.sinaapp.com/AppendStory"];
    req.timeout = 60;
    req.httpMethod = @"POST";
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    NSString* key = @"123456789012345678901234";
    NSString* iv = @"12345678";
    
    NSDictionary* dic = @{@"storyId":@(5),@"text":@"a new story",@"creator":@"someone"};
    
    NSString* plainParameter = [dic JSONRepresentation];
    
    
    NSLog(@"%@",plainParameter);
    
    
    NSString* parameters = [XYUtility encrypt:plainParameter key:key initVect:iv];
    NSDictionary* p = @{@"params":parameters};
    
    NSString* message = [p JSONRepresentation];
    NSLog(@"message:%@",message);
    NSData* body = [message dataUsingEncoding:NSUTF8StringEncoding];
    req.body = body;
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    NSLog(@"data:%@",result.data);
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",response);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:result.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
}


-(void)testCreateStory{
    
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    
    req.requestURL = [NSURL URLWithString:@"http://mariopython.sinaapp.com/CreateStory"];
    req.timeout = 60;
    req.httpMethod = @"POST";
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    NSString* key = @"123456789012345678901234";
    NSString* iv = @"12345678";
    
    NSDictionary* dic = @{@"text":@"a new story",@"creator":@"someone"};
    
    NSString* plainParameter = [dic JSONRepresentation];
    
    
    NSLog(@"%@",plainParameter);
    
    
    NSString* parameters = [XYUtility encrypt:plainParameter key:key initVect:iv];
    NSDictionary* p = @{@"params":parameters};
    
    NSString* message = [p JSONRepresentation];
    NSLog(@"message:%@",message);
    NSData* body = [message dataUsingEncoding:NSUTF8StringEncoding];
    req.body = body;
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    NSLog(@"data:%@",result.data);
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",response);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:result.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
}

-(void)testGetFullStory{
    
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    
    req.requestURL = [NSURL URLWithString:@"http://mariopython.sinaapp.com/GetFullStoryById"];
    req.timeout = 60;
    req.httpMethod = @"POST";
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    NSString* key = @"123456789012345678901234";
    NSString* iv = @"12345678";
    
    NSDictionary* dic = @{@"storyId":@(5)};
    
    NSString* plainParameter = [dic JSONRepresentation];
    
    
    NSLog(@"%@",plainParameter);
    
    
    NSString* parameters = [XYUtility encrypt:plainParameter key:key initVect:iv];
    NSDictionary* p = @{@"params":parameters};
    
    NSString* message = [p JSONRepresentation];
    NSLog(@"message:%@",message);
    NSData* body = [message dataUsingEncoding:NSUTF8StringEncoding];
    req.body = body;
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    NSLog(@"data:%@",result.data);
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",response);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:result.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
}


-(void)testParamsEncodePost{
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    
    req.requestURL = [NSURL URLWithString:@"http://mariopython.sinaapp.com/ParamsEncodePost"];
    req.timeout = 60;
    req.httpMethod = @"POST";
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    NSString* key = @"123456789012345678901234";
    NSString* iv = @"12345678";
    

    
    NSDictionary* dic = @{@"A":@"vvv",@"B":@"ccc"};
    
    NSString* password = [dic JSONRepresentation];
    
    
    NSLog(@"%@",password);
    
    
    NSString* parameters = [XYUtility encrypt:password key:key initVect:iv];
    NSDictionary* p = @{@"params":parameters};
    
    NSString* message = [p JSONRepresentation];
    NSLog(@"message:%@",message);
    NSData* body = [message dataUsingEncoding:NSUTF8StringEncoding];
    req.body = body;
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    NSLog(@"data:%@",result.data);
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",response);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:result.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
    //    return repObj;
    
    
    //    {"{\"params\":\"oG aFxrcqYc": ["\"}"]}
    //    {\"params\":\"oG+aFxrcqYc=\"}
}





-(void)testEncodePost{
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    
    req.requestURL = [NSURL URLWithString:@"http://mariopython.sinaapp.com/EncodePost"];
    req.timeout = 60;
    req.httpMethod = @"POST";
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    NSString* key = @"123456789012345678901234";
    NSString* iv = @"12345678";
    
    NSString* plainText = @"a";
    
    NSString* password = [XYUtility encrypt:plainText key:key initVect:iv];
    NSLog(@"%@",password);
    
    NSDictionary* p = @{@"params":password};
    
    NSString* message = [p JSONRepresentation];
    NSData* body = [message dataUsingEncoding:NSUTF8StringEncoding];
    req.body = body;
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    NSLog(@"data:%@",result.data);
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",response);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:result.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
    //    return repObj;
    
    
    //    {"{\"params\":\"oG aFxrcqYc": ["\"}"]}
    //    {\"params\":\"oG+aFxrcqYc=\"}
}

-(void)testPost{
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    
    req.requestURL = [NSURL URLWithString:@"http://mariopython.sinaapp.com/TestPost"];
    req.timeout = 60;
    req.httpMethod = @"POST";
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    NSString* key = @"0123456789abcdef";
    NSString* iv = @"";
    
    NSString* password = [XYUtility encrypt:@"12345678" key:key initVect:iv];

    NSDictionary* p = @{@"params":password};
    
    NSString* message = [p JSONRepresentation];
    NSData* body = [message dataUsingEncoding:NSUTF8StringEncoding];
    req.body = body;
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    NSLog(@"data:%@",result.data);
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",response);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:result.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
//    return repObj;

    
//    {"{\"params\":\"oG aFxrcqYc": ["\"}"]}
//    {\"params\":\"oG+aFxrcqYc=\"}
}

-(void)log:(NSString *)logString{
    NSLog(@"%@",logString);
}

-(void)testEncrypt3{
    NSString* key = @"12345678901234567890";
    NSString* iv = @"123456";
    
    NSString* password = [XYUtility encrypt:@"0000000t" key:key initVect:iv];
    
    // f5d28f3c 07d869a7 4f191b63 309c20af
    // 1111 0101 1101 0010 1000 1111 0011 1100
    // a25e2324 9b944d3f 9335cc2f c785c26b
    // 1010 0010 0101 1110 0010 0011 0010 0100
    // 6ae4dfe1 766a5d3a 35997b8e 07a9637a c9bff0bbb93dbfd6
    // 0110 1010 1110 0100 1101 1111 1110 0001
    NSLog(@"%@",password);
    password = [XYUtility decrypt:password key:key initVect:iv];
    NSLog(@"original string:%@",password);

}

-(void)testEncrypt2{
    
    NSLog(@"%@",[XYUtility appVersion]);
    
    NSString* key = @"123456789012345678901234";
    NSString* iv = @"12345678";
    //    NSString* iv = @"";
    NSString* enStr = [XYUtility encrypt:@"" key:key initVect:iv];
    // ios
    //1153906d 287305fd f7439109 9cb78e1d
    // python
    //cde17b48 ee9b2a5d ac712ddd bcffa1cc
    
    NSLog(@"encrypted string:%@",enStr);
    
    enStr = [XYUtility decrypt:enStr key:key initVect:iv];
    NSLog(@"original string:%@",enStr);
    
    
}

//ios
// 0000000100000002
// f5d28f3c 07d869a7 61683350 10914511 d5a1e989 e4b07bae

// 00000001
// +8
// f5d28f3c 07d869a7 4f191b63 309c20af
// f5       d2       8f       3c       07
// 11110101 11010010 10001111 00111100 00000111
//
// d8       69a7     4f       19       1b
// 11011000 01101001 01001111 00011001 00011011
// 63       30       9c       20       af
// 01100011 00110000 10011100 00100000 10101111


// 00000001\0\0\0\0\0\0\0\0
// f5d28f3c 07d869a7 82d983bb 6ab71e33 6f168dc1 b920edaa

// python
// 00000001
// 6ae4dfe1 766a5d3a 35997b8e 07a9637ac 9bff0bbb 93dbfd6

// 00000001 00000002
// 6ae4dfe1 766a5d3a 35997b8e 07a9637ab b3c102fc 242008c
// 67affa29 818d78c1 b56bac6c 428c5b4d
-(void)testEncrypt{

    NSLog(@"%@",[XYUtility appVersion]);
    
    NSString* key = @"0123456789abcdef";
    NSString* iv = @"";
//    NSString* iv = @"";
    NSString* enStr = [XYUtility encrypt:@"abcdefgh" key:key initVect:iv];
    NSLog(@"encrypted string:%@",enStr);
    
    enStr = [XYUtility decrypt:enStr key:key initVect:iv];
    NSLog(@"original string:%@",enStr);
    
   
}

-(void)testBase64{
    NSString* oText = @"abc";
    NSData* oTextData = [oText dataUsingEncoding:NSUTF8StringEncoding];
    NSData* tTextData = [GTMBase64 encodeData:oTextData];
    NSString* tText = [[NSString alloc] initWithData:tTextData encoding:NSUTF8StringEncoding];
    NSLog(@"tText:%@",tText);
    
    NSData* decodeTextData = [GTMBase64 decodeData:tTextData];
    NSString* decodeText = [[NSString alloc] initWithData:decodeTextData encoding:NSUTF8StringEncoding];
    NSLog(@"decodeText:%@",decodeText);
}

-(void)testConnectorDictRequest{
    
    NSString* url = @"http://mariopython.sinaapp.com";
    //    NSString* url = @"http://192.168.1.4";
    
    //    [[XYConnectorManager instance] initConnectorWithURL:url asAlias:@"_connector"];
    //
    //    XYConnector* connector = [[XYConnectorManager instance] connectorByAlias:@"_connector"];
    
    // Connector gives url
    XYConnector* connector = [[XYConnector alloc] initWithURL:url];
    
    // Connection process detail sending
    XYConnection* connection = [XYConnection new];
    connector.connection = connection;
    
    // Message engine manage multiple connectors
    [[XYMessageEngine instance] setConnector:connector forStage:XYMessageStageDevelopment];
    
    // Message engine delegate
    [XYMessageEngine instance].delegate = self;
    
    // Register message configuration
    MessageConfig* mc = [MessageConfig new];
    mc.relativePath = @"Item";
//    [[XYMessageEngine instance].messageUrlMapping setObject:mc forKey:NSStringFromClass([XYDictRequest class])];
    
    [[XYMessageEngine instance] setConfig:mc forMessage:[XYDictRequest class]];
    
    
    [XYMessageEngine instance].runningStage = XYMessageStageDevelopment;
    
    XYDictRequest* itemRequest = [XYDictRequest new];
    
    XYDictResponse* itemResponse = (XYDictResponse*)[[XYMessageEngine instance] send:itemRequest];
    
    NSLog(@"%@",itemResponse);
}

-(void)testConnector{
    
    NSString* url = @"http://mariopython.sinaapp.com";
//    NSString* url = @"http://192.168.1.4";
    
//    [[XYConnectorManager instance] initConnectorWithURL:url asAlias:@"_connector"];
//    
//    XYConnector* connector = [[XYConnectorManager instance] connectorByAlias:@"_connector"];

    // Connector gives url
    XYConnector* connector = [[XYConnector alloc] initWithURL:url];
    
    // Connection process detail sending
    XYConnection* connection = [XYConnection new];
    connector.connection = connection;
    
    // Message engine manage multiple connectors
    [[XYMessageEngine instance] setConnector:connector forStage:XYMessageStageDevelopment];
    
    // Message engine delegate
    [XYMessageEngine instance].delegate = self;
    
    // Register message configuration
    MessageConfig* mc = [MessageConfig new];
    mc.relativePath = @"Item";
    
    [[XYMessageEngine instance] setConfig:mc forMessage:[ItemRequest class]];
    
    [XYMessageEngine instance].runningStage = XYMessageStageDevelopment;
    
    ItemRequest* itemRequest = [ItemRequest new];
    
    ItemResponse* itemResponse = (ItemResponse*)[[XYMessageEngine instance] send:itemRequest];
    
    NSLog(@"%@",itemResponse);
}


-(id)testJsonResponse{
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    
    req.requestURL = [NSURL URLWithString:@"http://mariopython.sinaapp.com/Login"];
    req.timeout = 60;
    req.httpMethod = @"GET";
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:result.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
    return repObj;
}


-(void)testNormal{
    XYConnection* connection = [XYConnection new];
    
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    req.requestURL = [NSURL URLWithString:@"http://www.baidu.com/s?wd=__IPHONE_OS_VERION_MAX_ALLOWED&pn=10&oq=__IPHONE_OS_VERION_MAX_ALLOWED&tn=baiduhome_pg&ie=utf-8&rsv_idx=2&rsv_pq=a01c6fdf00000f08&rsv_t=253fZHR9UXmkWFXEequfmrBqrKEpE2bnFWs6K9BtTIT1lsw0EQijvWXCgwFsJSsse%2Bhh&rsv_page=1&rsv_spt=1&issp=1&f=8&rsv_bp=0"];
    req.timeout = 60;
    req.httpMethod = @"POST";
    
    
    XYHTTPResponseObject* result = [connection sendRequest:req];
    
    NSString* response = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
