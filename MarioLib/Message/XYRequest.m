//
//  XYRequest.m
//  XYUIDesign
//
//  Created by AGS XY on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XYRequest.h"

@implementation XYRequest

@end

@implementation XYDictRequest
{
    NSMutableDictionary* _requestDict;
}
@synthesize name = _name;
-(id)init{
    if (self = [super init]) {
        _requestDict = [NSMutableDictionary new];
    }
    return self;
}
-(void)setValue:(id)value forKey:(NSString *)key{
    [_requestDict setObject:value forKey:key];
}
-(id)valueForKey:(NSString *)key{
    return [_requestDict objectForKey:key];
}
@end

@implementation XYAppRequest
@synthesize memberId;
@synthesize uniqueGlobalDeviceIdentifier;
@synthesize deviceString;
@end

@implementation XYLoginRequest
@synthesize mobile;
@synthesize password;
@end