//
//  XYCoreDataManager.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 6/14/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYCoreDataManager.h"

static XYCoreDataManager* instance;

@implementation XYCoreDataManager
{
    NSMutableDictionary* coreDataCache;
}
+(XYCoreDataManager*)instance{
    if (instance == nil) {
        instance = [XYCoreDataManager new];
    }
    return instance;
}

-(void)initCoreDataConnectorWithModel:(NSString*) model storeName:(NSString *)name asAlias:(NSString*)alias{
    if (coreDataCache == nil) {
        coreDataCache = [NSMutableDictionary new];
    }
    
    if ([coreDataCache objectForKey:alias] == nil) {
        XYCoreDataConnector* connector = [[XYCoreDataConnector alloc] initWithModelName:model storeName:name];
        [coreDataCache setObject:connector forKey:alias];
    }
}

// Get XYCoreDataConnector by alias name
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias{
    return [self connectorByAlias:alias newContext:YES];
}

// Get XYCoreDataConnector by alias name
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias newContext:(BOOL) newContext{
    XYCoreDataConnector* connector = [coreDataCache objectForKey:alias];
    if (connector == nil) {
        [[XYBaseErrorCenter instance] recordErrorWithTitle:@"XYCoreDataConnector Error" detail:@"connectorByAlias return nil"];
        return nil;
        //@throw [NSException exceptionWithName:@"NilXYCoreDataConnector" reason:@"connectorByAlias got nil connect" userInfo:nil];
    }
    if (newContext) {
        return [[XYCoreDataConnector alloc] initWithModelName:connector.modelName storeName:connector.storeName];
    }

    return connector;
}

// Remove connector
-(void)removeConnectorByAlias:(NSString*)alias{
    [coreDataCache removeObjectForKey:alias];
}

-(void)removeAllConnectors{
    [coreDataCache removeAllObjects];
}


@end
