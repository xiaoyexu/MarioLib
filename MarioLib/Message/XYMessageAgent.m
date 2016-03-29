//
//  XYMessageAgent.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/5/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYMessageAgent.h"

@implementation XYMessageAgent
-(void)normalize:(XYRequest*)request to:(XYHTTPRequestObject*) requestObj{
    
}
-(void)deNormalize:(XYHTTPResponseObject*)responseObj to:(XYResponse**)response{
//    NSString* resStr = [[NSString alloc] initWithData:responseObj.data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",resStr);
//    
//    id repObj = [NSJSONSerialization JSONObjectWithData:responseObj.data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@",repObj);
//    
//    (*response).responseCode = [[repObj objectForKey:@"responseCode"] integerValue];
//    (*response).responseDesc = [repObj objectForKey:@"responseDesc"];
}
@end

@implementation XYDictMessageAgent

-(void)normalize:(XYRequest *)request to:(XYHTTPRequestObject *)requestObj{
    NSLog(@"%@",request);
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    Class cls = [request class];
    unsigned int ivarsCnt = 0;
    objc_property_t *properties = class_copyPropertyList(cls,&ivarsCnt);
    for (int i = 0 ; i < ivarsCnt ; i++) {
        objc_property_t property = properties[i];
        const char* propname = property_getName(property);
        if (propname) {
            NSString* propertyName = [NSString stringWithUTF8String:propname];
            NSString* restName = [propertyName substringFromIndex:1];
            NSString* getName = propertyName;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSString* propertyValue = [request performSelector:NSSelectorFromString(getName)];
            
            NSLog(@"%@ %@",propertyName, propertyValue);
            [dict setObject:propertyValue forKey:propertyName];
        }
    }

    NSLog(@"dic %@",dict);
    
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    requestObj.headers = header;
    
    NSString* key = @"123456789012345678901234";
    NSString* iv = @"12345678";
    
//    NSDictionary* dic = @{@"storyId":@(5),@"text":@"a new story",@"creator":@"someone"};
    
    NSString* plainParameter = [dict JSONRepresentation];
    
    
    NSLog(@"%@",plainParameter);
    
    
    NSString* parameters = [XYUtility encrypt:plainParameter key:key initVect:iv];
    NSDictionary* p = @{@"params":parameters};
    
    NSString* message = [p JSONRepresentation];
    NSLog(@"message:%@",message);
    NSData* body = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",body);
    requestObj.body = body;
    
  
    
}

-(void)deNormalize:(XYHTTPResponseObject *)responseObj to:(XYResponse *__autoreleasing *)response{
    
//    XYDictResponse* itemResponse = [XYDictResponse new];
//    
//    [super deNormalize:responseObj to:&itemResponse];
//    
    if ([*response isKindOfClass:[XYDictResponse class]]) {
        XYDictResponse* dicRes = (XYDictResponse*)*response;
        [dicRes setJSONData:responseObj.data];
        
    }
    
    
    
    
//
//    [itemResponse setValue:[repObj objectForKey:@"id"] forKey:@"itemId"];
//    [itemResponse setValue:[repObj objectForKey:@"property1"] forKey:@"property1"];
//    [itemResponse setValue:[repObj objectForKey:@"property2"] forKey:@"property2"];
//    [itemResponse setValue:[repObj objectForKey:@"property3"] forKey:@"property3"];
//
}

-(XYResponse*)demoResponse{
//    XYDictResponse* response = [XYDictResponse new];
//    [response setValue:@"1111" forKey:@"itemId"];
//    [response setValue:@"demo1" forKey:@"property1"];
//    [response setValue:@"demo2" forKey:@"property2"];
//    [response setValue:@"demo3" forKey:@"property3"];
//    return response;
    return nil;
}

@end
