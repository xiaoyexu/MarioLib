//
//  XYProcessResult.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYProcessResult.h"

@implementation XYProcessResult
@synthesize type = _type;
@synthesize success = _success;
@synthesize params = _params;
@synthesize forwardSegueIdentifer = _forwardSegueIdentifer;

-(id)init{
    self = [super init];
    if (self) {
        _params = [NSMutableDictionary new];
    }
    return self;
}
+(XYProcessResult*)success{
    XYProcessResult* result = [XYProcessResult new];
    result.success = YES;
    return result;
}
+(XYProcessResult*)failure{
    XYProcessResult* result = [XYProcessResult new];
    result.success = NO;
    return result;
}
@end
