//
//  MessageItem.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/5/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "MessageItem.h"

@implementation ItemRequest
@synthesize itemId;
@end

@implementation ItemResponse
@synthesize itemId;
@synthesize property1;
@synthesize property2;
@synthesize property3;
@end

@implementation ItemMessageAgent

-(void)normalize:(XYRequest *)request to:(XYHTTPRequestObject *)requestObj{

}

-(void)deNormalize:(XYHTTPResponseObject *)responseObj to:(XYResponse *__autoreleasing *)response{
    ItemResponse* itemResponse = [ItemResponse new];
    
    [super deNormalize:responseObj to:&itemResponse];
    
    NSString* resStr = [[NSString alloc] initWithData:responseObj.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resStr);
    
    id repObj = [NSJSONSerialization JSONObjectWithData:responseObj.data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",repObj);
    
    itemResponse.itemId = [repObj objectForKey:@"id"];
    itemResponse.property1 = [repObj objectForKey:@"property1"];
    itemResponse.property2 = [repObj objectForKey:@"property2"];
    itemResponse.property3 = [repObj objectForKey:@"property3"];
    
    *response = itemResponse;
}

-(XYResponse*)demoResponse{
    ItemResponse* response = [ItemResponse new];
    response.itemId = @"1111";
    response.property1 = @"demo1";
    response.property2 = @"demo2";
    response.property3 = @"demo3";
    return response;
}

@end
