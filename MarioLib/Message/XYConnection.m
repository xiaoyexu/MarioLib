//
//  XYConnection.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 1/20/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYConnection.h"

@implementation XYHTTPRequestObject
@synthesize requestURL = _requestURL;
@synthesize policy = _policy;
@synthesize timeout = _timeout;
@synthesize httpMethod = _httpMethod;
@synthesize headers = _headers;
@synthesize body = _body;
@end

@implementation XYHTTPResponseObject
@synthesize data = _data;
@synthesize response = _response;
-(id)initWithData:(NSData*)data urlResponse:(NSURLResponse*)response{
    if (self = [super init]) {
        _data = data;
        _response = response;
    }
    return self;
}
@end

@implementation XYConnection
{
    NSURLResponse* _urlresponse;
    NSMutableData* _data;
    BOOL _finished;
}

-(id)init{
    if (self = [super init]) {
        _data = [NSMutableData new];
    }
    return self;
}

-(XYHTTPResponseObject*)sendRequest:(XYHTTPRequestObject *)reqObj{
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:reqObj.requestURL cachePolicy:reqObj.policy timeoutInterval:reqObj.timeout];
    
//    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    
//    
//    
//    if (![urlRequest valueForHTTPHeaderField:@"Content-Type"]) {
//        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    }
//    
//    [urlRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    
    
    
//    [urlRequest setValue:@(5) forKey:@"timeInterval"];
    urlRequest.HTTPMethod = reqObj.httpMethod;
    
    // Header data
    for (NSString* header in [reqObj.headers allKeys]) {
        [urlRequest setValue:[reqObj.headers valueForKey:header] forHTTPHeaderField:header];
    }
    // Request data
    [urlRequest setHTTPBody:reqObj.body];
    
    NSURLResponse* uresponse;
//    NSHTTPURLResponse* uresponse;
    NSData* data;
    @try {
//        [NSURLConnection connectionWithRequest:urlRequest delegate:self];

        data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&uresponse error:nil];
        NSLog(@"response data:%@",data);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    // Waiting until got response
//    while(!_finished) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
    
//    XYHTTPResponseObject* response = [[XYHTTPResponseObject alloc] initWithData:_data urlResponse:_urlresponse];
    XYHTTPResponseObject* response = [[XYHTTPResponseObject alloc] initWithData:data urlResponse:uresponse];
    
    return response;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _urlresponse = response;
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _finished = NO;
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

    _finished = YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    [[SALBaseErrorCenter instance] recordErrorWithTitle:@"SALConnectionError" detail:error.debugDescription level:SALErrorLevelHigh];
    _finished = YES;
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    } else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]) {
        if (challenge.previousFailureCount == 0) {
//            [challenge.sender useCredential:[NSURLCredential credentialWithIdentity:self.identity certificates:nil persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
        } else {
            [challenge.sender rejectProtectionSpaceAndContinueWithChallenge:challenge];
        }
        
    } else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault]) {
        [challenge.sender rejectProtectionSpaceAndContinueWithChallenge:challenge];
    } else {
        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
    }
    
    if (challenge.previousFailureCount > 2) {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
    
}

@end