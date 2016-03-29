//
//  XYConnection.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 1/20/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYRequest.h"
#import "XYResponse.h"
#import "XYUtility.h"
#import "XYConnector.h"

//#import "AFNetworking.h"
//#import "AFJSONRequestOperation.h"
/**
 Base object for http request
 */
@interface XYHTTPRequestObject : NSObject
@property(nonatomic, strong) NSURL* requestURL;
@property(nonatomic) NSURLRequestCachePolicy policy;
@property(nonatomic) NSTimeInterval timeout;
@property(nonatomic) NSString* httpMethod;
@property(nonatomic) NSDictionary* headers;
@property(nonatomic) NSData* body;
@end

@interface XYHTTPResponseObject : NSObject
@property(nonatomic,strong, readonly) NSData* data;
@property(nonatomic,strong, readonly) NSURLResponse* response;
-(id)initWithData:(NSData*)data urlResponse:(NSURLResponse*)response;
@end

@protocol XYConnectionDelegate <NSObject>

-(XYHTTPResponseObject*)sendRequest:(XYHTTPRequestObject*)reqObj;

@end

/**
 This class only responsible for HTTP request sending
 */
@interface XYConnection : NSObject<XYConnectionDelegate,NSURLConnectionDataDelegate>
/**
 This is synchronous method
 */
-(XYHTTPResponseObject*)sendRequest:(XYHTTPRequestObject*)reqObj;
@end