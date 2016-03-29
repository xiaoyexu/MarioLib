//
//  XYConnector.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/3/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYConnection;
@interface XYConnector : NSObject
@property (nonatomic, readonly) NSURL* url;
@property (nonatomic, strong) XYConnection* connection;
/**
 Initialization method
 */
-(id)init;


-(id)initWithConnector:(XYConnector*)connector;

/**
 Init method with URL. URL should be full path e.g. "https://pgpmain.wdf.sap.corp/sap/opu/odata/sap/ZS_ESCALATIONS/"
 The mode SALConnectorModeGateway will be set as default
 @param url Full url string. E.g "https://server/services"
 */
-(id)initWithURL:(NSString*)url;

/**
 Init method with URL and flag for connection test
 The mode SALConnectorModeGateway will be set as default
 @param url Full url string. E.g "https://server/services"
 @param connect If YES try connect immediately for service document and metadata
 */
//-(id)initWithURL:(NSString*)url connectNow:(BOOL) connect;

/**
 Refresh connector by url
 @param url Full url string. E.g "https://server/services"
 */
-(void)refreshWithURL:(NSString *)url;

/**
 Connect now to get service document, metadata
 */
-(void)connectNow;
@end
