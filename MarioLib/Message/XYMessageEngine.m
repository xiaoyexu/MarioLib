//
//  XYMessageEngine.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/5/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYMessageEngine.h"

static XYMessageEngine* instance;

@implementation MessageConfig
@synthesize relativePath;
@synthesize httpMethod;
@end


@implementation XYMessageEngine
{
    NSMutableDictionary* _messageStage;
    NSMutableDictionary* _messageConfigMapping;
}
@synthesize runningStage = _runningStage;
@synthesize messageStage = _messageStage;
@synthesize messageConfigMapping = _messageConfigMapping;
@synthesize delegate = _delegate;
+(XYMessageEngine*)instance{
    if (instance == nil) {
        instance = [XYMessageEngine new];
    }
    return instance;
}

-(id)init{
    if (self = [super init]) {
        _messageStage = [NSMutableDictionary new];
        _messageConfigMapping = [NSMutableDictionary new];
    }
    return self;
}

-(void)setConnector:(XYConnector *)connector forStage:(XYMessageStage)stage{
    [_messageStage setObject:connector forKey:[NSNumber numberWithInteger:stage]];
}

-(void)removeConnectorOfStage:(XYMessageStage)stage{
    [_messageStage removeObjectForKey:[NSNumber numberWithInteger:stage]];
}

-(void)setConfig:(MessageConfig*)config forMessage:(Class)messageClass{
    [_messageConfigMapping setObject:config forKey:NSStringFromClass(messageClass)];
}

-(void)removeConfigOfMessage:(Class)messageClass{
    [_messageConfigMapping removeObjectForKey:NSStringFromClass(messageClass)];
}

/**
 
 */
-(XYResponse*)send:(XYRequest *)request{
    
    // Get message name from request class
    NSString* messageClassName = NSStringFromClass(request.class);
    NSString* messageName = [XYMessageEngine getMessageNameFrom:messageClassName];
    
    if (_runningStage == XYMessageStageDemo) {
        // If demo mode, return pre-defined response
        id<XYMessageAgent> agent = (id<XYMessageAgent>)[XYMessageEngine getMessageFormatterByName:messageName];
        return [agent demoResponse];
    }
    
    // Request/Response object
    XYResponse* response;
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    XYHTTPResponseObject* res = [XYHTTPResponseObject new];
    
    XYConnector* connector = [_messageStage objectForKey:[NSNumber numberWithInt:_runningStage]];
    
    if (connector == nil) {
        // No connector available
        return nil;
    }
    
    MessageConfig* mc = [_messageConfigMapping objectForKey:messageClassName];
    NSString* url = [connector.url absoluteString];
    
    // Get URL configuration
    if (![XYUtility isBlank:mc.relativePath]) {
        url = [NSString stringWithFormat:@"%@/%@",url,mc.relativePath];
    }
    
    req.requestURL = [NSURL URLWithString:url];
    
    // Default timeout
    req.timeout = 60;
    
    // Default method
    req.httpMethod = [XYUtility isBlank:mc.httpMethod] ? @"GET" : mc.httpMethod;
    
    // Default header
    NSDictionary* header = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    req.headers = header;
    
    @try {
        id<XYMessageAgent> agent = (id<XYMessageAgent>)[XYMessageEngine getMessageFormatterByName:messageName];
        if (agent != nil) {
            [agent normalize:request to:req];
        }
        
        res = [connector.connection sendRequest:req];
        
        NSString* resStr = [[NSString alloc] initWithData:res.data encoding:NSUTF8StringEncoding];
        [self.delegate log:[NSString stringWithFormat:@"Response:%@",resStr]];
        
        if ([res.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse* response = (NSHTTPURLResponse*)res.response;
            if (response.statusCode != 200) {
                @throw [NSException exceptionWithName:@"HTTP response error" reason:[NSString stringWithFormat:@"HTTP response:%ld",(long)response.statusCode] userInfo:nil];
            }
            
        }
        
        if (agent != nil) {
            [agent deNormalize:res to:&response];
        }
    }
    @catch (NSException *exception) {
        [self.delegate log:[NSString stringWithFormat:@"Error:%@",exception.description]];
    }
    
    return response;
}


+(id<XYMessageAgent>)getMessageFormatterByName:(NSString*)name{
    NSString* request_class_name =  [self getMessageFormatterClassNameByName:name];
    id request_class = [[NSClassFromString(request_class_name) alloc] init];
    return request_class;
    
}

+(NSString*)getMessageFormatterClassNameByName:(NSString*)name{
    if (name == nil || [name isEqualToString:@""]) {
        name = @"";
    }
    NSString* request_class_name = @"##_TYPE_##MessageAgent";
    request_class_name = [request_class_name stringByReplacingOccurrencesOfString:@"##_TYPE_##" withString:name];
    return request_class_name;
}

+(NSString*)getMessageNameFrom:(NSString*)className{
    NSArray* result = [XYUtility matchStringListOfString:className matchRegularExpression:@"(.*)(Request|Response)"];
    if (result.count > 0) {
        return [result objectAtIndex:0];
    }
    return @"";
}


//+(NSString*)getMessageNameFrom:(Class)class{
//    NSString* className = NSStringFromClass(class);
//    NSArray* result = [XYUtility matchStringListOfString:className matchRegularExpression:@"(.*)(Request|Response)"];
//    if (result.count > 0) {
//        return [result objectAtIndex:0];
//    }
//    return @"";
//}
@end
