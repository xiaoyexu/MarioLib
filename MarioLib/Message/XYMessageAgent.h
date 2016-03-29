//
//  XYMessageAgent.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/5/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYRequest.h"
#import "XYResponse.h"
#import "XYConnection.h"
#import "SBJson.h"

@protocol XYMessageAgent <NSObject>
-(void)normalize:(XYRequest*)request to:(XYHTTPRequestObject*) requestObj;
-(void)deNormalize:(XYHTTPResponseObject*)responseObj to:(XYResponse**)response;
@optional
-(XYResponse*)demoResponse;
@end


@interface XYMessageAgent : NSObject<XYMessageAgent>

@end


@interface XYDictMessageAgent : XYMessageAgent

@end