//
//  XYConnector.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/3/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYConnector.h"

@implementation XYConnector
{
    NSURL* _url;
    NSString* _urlString;
}
@synthesize url = _url;
@synthesize connection = _connection;
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithConnector:(XYConnector *)connector{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithURL:(NSString *)url{
    if (self = [super init]) {
        _urlString = url;
        _url = [NSURL URLWithString:_urlString];
    }
    return self;
}

//-(id)initWithURL:(NSString *)url connectNow:(BOOL)connect{
//    if (self = [super init]) {
//        
//    }
//    return self;
//}

-(void)refreshWithURL:(NSString *)url{
    _urlString = url;
    _url = [NSURL URLWithString:_urlString];
}

-(void)connectNow{
    
}
@end
