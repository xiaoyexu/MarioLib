//
//  XYConnectorManager.m
//  SALUIDesignTest
//
//  Created by Xu Xiaoye on 5/14/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import "XYConnectorManager.h"

static XYConnectorManager* instance;

@implementation XYConnectorManager
{
    // For cache the connector
    NSMutableDictionary* _gatewayCache;
}
+(XYConnectorManager*)instance{
    if (instance == nil) {
        instance = [XYConnectorManager new];
    }
    return instance;
}

-(id)init{
    if (self = [super init]) {
        _gatewayCache = [NSMutableDictionary new];
    }
    return self;
}

-(void)initConnectorWithURL:(NSString *)url asAlias:(NSString*)alias{
//    [self initGatewayWithURL:url asAlias:alias connectNow:NO];
    if ([_gatewayCache objectForKey:alias] != nil) {
        [_gatewayCache removeObjectForKey:alias];
    }
    XYConnector* connector = [[XYConnector alloc] initWithURL:url];
    [_gatewayCache setObject:connector forKey:alias];
}

//-(void)initGatewayWithURL:(NSString *)url asAlias:(NSString*)alias connectNow:(BOOL) connect{
//    if ([gatewayCache objectForKey:alias] != nil) {
//        [gatewayCache removeObjectForKey:alias];
//    }
//    XYConnector* connector = [[XYConnector alloc] initWithURL:url connectNow:connect];
//    [gatewayCache setObject:connector forKey:alias];
//}

-(void)refreshConnectorWithURL:(NSString *)url forAlias:(NSString *)alias{
    XYConnector* connector = [_gatewayCache objectForKey:alias];
    if (connector != nil) {
        [connector refreshWithURL:url];
    } else {
        connector = [[XYConnector alloc] initWithURL:url];
        [_gatewayCache setObject:connector forKey:alias];
    }
    
//    XYConnector* oldConnect = [gatewayCache objectForKey:alias];
//    XYConnector* connector;
//    if (oldConnect != nil) {
//        [oldConnect refreshWithURL:url];
//        if (oldConnect.shouldConnectAfterInitialized) {
//            [oldConnect connectNow];
//        }
//        //connector = [[XYConnector alloc] initWithURL:url connectNow:oldConnect.shouldConnectAfterInitialized];
//        [gatewayCache setObject:oldConnect forKey:alias];
//    } else {
//        connector = [[XYConnector alloc] initWithURL:url];
//        [gatewayCache setObject:connector forKey:alias];
//    }
    
}

//-(void)initGatewayWithDomain:(NSString*)domain service:(NSString*)service asAlias:(NSString*)alias{
//    [self initGatewayWithDomain:domain service:service asAlias:alias connectNow:NO];
//}
//
//-(void)initGatewayWithDomain:(NSString*)domain service:(NSString*)service asAlias:(NSString*)alias connectNow:(BOOL) connect{
//    if ([gatewayCache objectForKey:alias] != nil) {
//        [gatewayCache removeObjectForKey:alias];
//    }
//    XYConnector* connector = [[XYConnector alloc] initWithDomain:domain service:service connectNow:connect];
//    [gatewayCache setObject:connector forKey:alias];
//}

//-(void)refreshGatewayWithDomain:(NSString*)domain service:(NSString*)service forAlias:(NSString*)alias{
//    XYConnector* oldConnect = [gatewayCache objectForKey:alias];
//    XYConnector* connector;
//    if (oldConnect != nil) {
//        
//        [oldConnect refreshWithDomain:domain service:service];
//        if (oldConnect.shouldConnectAfterInitialized) {
//            [oldConnect connectNow];
//        }
//        //connector = [[XYConnector alloc] initWithDomain:domain service:service connectNow:oldConnect.shouldConnectAfterInitialized];
//        [gatewayCache setObject:oldConnect forKey:alias];
//    } else {
//        connector = [[XYConnector alloc] initWithDomain:domain service:service];
//        [gatewayCache setObject:connector forKey:alias];
//    }
//}

-(XYConnector*)connectorByAlias:(NSString*)alias{
    XYConnector* connector = [_gatewayCache objectForKey:alias];
    return connector;
}

-(XYConnector*)newConnectorByAlias:(NSString *)alias{
    XYConnector* connector = [_gatewayCache objectForKey:alias];
    
    XYConnector* newConnector = [[XYConnector alloc] initWithConnector:connector];
    return newConnector;
}

-(void)addConnector:(XYConnector*) connector asAlias:(NSString*) alias{
    [_gatewayCache setObject:connector forKey:alias];
}

-(void)removeConnectorByAlias:(NSString*)alias{
    [_gatewayCache removeObjectForKey:alias];
}

-(void)removeAllConnectors{
    [_gatewayCache removeAllObjects];
}

@end
