//
//  XYConnectorManager.h
//  SALUIDesignTest
//
//  Created by Xu Xiaoye on 5/14/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYConnector.h"

/**
 This class manage SALGateConnector objects
 */
@interface XYConnectorManager : NSObject

/**
 Singleton method to get XYConnectorManager
 */
+(XYConnectorManager*)instance;

/**
 Create the XYConnector
 */
-(void)initConnectorWithURL:(NSString *)url asAlias:(NSString*)alias;

/**
 Create the XYConnector and get the service document/metadata based on connect flag
 Exception may raised if connect is YES for any error
 */
//-(void)initGatewayWithURL:(NSString *)url asAlias:(NSString*)alias connectNow:(BOOL) connect;

/**
 Refresh gateway by url
 */
-(void)refreshConnectorWithURL:(NSString *)url forAlias:(NSString*)alias;

/**
 Create XYConnector with domain and service name
 */
//-(void)initGatewayWithDomain:(NSString*)domain service:(NSString*)service asAlias:(NSString*)alias;

/**
 Create XYConnector with domain and service name, indicate whether to connect immediately
 */
//-(void)initGatewayWithDomain:(NSString*)domain service:(NSString*)service asAlias:(NSString*)alias connectNow:(BOOL) connect;

/**
  Refresh domain and service for alias, if nil is pass, means value is unchanged
 */
//-(void)refreshGatewayWithDomain:(NSString*)domain service:(NSString*)service forAlias:(NSString*)alias;

/**
 Get XYConnector by alias name
 */
-(XYConnector*)connectorByAlias:(NSString*)alias;

/**
 Get a new XYConnector by alias name
 */
-(XYConnector*)newConnectorByAlias:(NSString*)alias;

/**
 Add connector
 */
-(void)addConnector:(XYConnector*) connector asAlias:(NSString*) alias;
/**
 Remove connector
 */
-(void)removeConnectorByAlias:(NSString*)alias;

/**
 Remove all connectors
 */
-(void)removeAllConnectors;
@end
