//
//  SALResponse.m
//  SALUIDesign
//
//  Created by AGS SAL on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XYResponse.h"

@implementation XYResponse
@synthesize responseCode;
@synthesize responseDesc;
@end

@implementation XYDictResponse
{
    NSMutableDictionary* _responseDict;
}
@synthesize name = _name;
-(id)init{
    if (self = [super init]) {
        _responseDict = [NSMutableDictionary new];
    }
    return self;
}

-(id)initWithJSONString:(NSData*)jsonData{
    if (self = [super init]) {
        [self setJSONData:jsonData];
    }
    return self;
}

-(void)setJSONData:(NSData *)jsonData{
    id repObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
    if ([repObj isKindOfClass:[NSDictionary class]]) {
        _responseDict = [[NSMutableDictionary alloc] initWithDictionary:repObj];
    } else {
        _responseDict = [NSMutableDictionary new];
    }
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [_responseDict setObject:value forKey:key];
    
}
-(id)valueForKey:(NSString *)key{
    return [_responseDict objectForKey:key];
}
@end

@implementation XYLoginResponse
@synthesize nickName;
@end