//
//  XYMessageEngine.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/5/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYMessageAgent.h"

@protocol XYMessageEngineDelegate<NSObject>

@optional
/**
 If logging is turn on, this method will be called to log request/response information
 */
-(void)log:(NSString*)logString;

@end

/**
 Message configuration for a single message
 */
@interface MessageConfig : NSObject
@property (nonatomic, strong) NSString* relativePath;
@property (nonatomic, strong) NSString* httpMethod;
@end

@protocol XYMessageEngine<NSObject>
-(XYResponse*)send:(XYRequest*)request;
@end

@interface XYMessageEngine : NSObject<XYMessageEngine>
/**
 Indicator which stage message engine is running
 */
@property (nonatomic) XYMessageStage runningStage;

/**
 Message stage mapping
 */
@property (nonatomic, readonly) NSMutableDictionary* messageStage;

/**
 Message relative url mapping
 Domain is defined by XYConnector, e.g. www.test.com
 Relative url is defined by each message, e.g.
 www.test.com/Login   <-> LoginRequest
 
 */
@property (nonatomic, readonly) NSMutableDictionary* messageConfigMapping;

/**
 Delegate
 */
@property (nonatomic, strong) id<XYMessageEngineDelegate> delegate;

/**
 Singleton instance
 */
+(XYMessageEngine*)instance;

/**
 Set connector for stage
 */
-(void)setConnector:(XYConnector*)connector forStage:(XYMessageStage)stage;

/**
 Remove connector
 */
-(void)removeConnectorOfStage:(XYMessageStage)stage;

/**
 Set config for message
 */
-(void)setConfig:(MessageConfig*)config forMessage:(Class)messageClass;

/**
 Remove config
 */
-(void)removeConfigOfMessage:(Class)messageClass;
@end
