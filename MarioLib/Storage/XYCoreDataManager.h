//
//  XYCoreDataManager.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 6/14/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYCoreDataConnector.h"

/**
 This class manage XYCoreDataConnector objects
 */
@interface XYCoreDataManager : NSObject

/**
 Static method to get instance
 */
+(XYCoreDataManager*)instance;

/**
 Create and cache the core data connector
 @param model Model name
 @param name Store file name
 @param alias Alias for the connector
 */
-(void)initCoreDataConnectorWithModel:(NSString*) model storeName:(NSString *)name asAlias:(NSString*)alias;

/**
 Get XYCoreDataConnector by alias name, always returnning a new instance/context
 */
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias;

/**
 Get XYCoreDataConnector by alias name
 */
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias newContext:(BOOL) newContext;

/**
 Remove connector
 */
-(void)removeConnectorByAlias:(NSString*)alias;

/**
 Remove all connectors
 */
-(void)removeAllConnectors;
@end
