//
//  SALSelectorObject.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import "XYSelectorObject.h"

@implementation XYSelectorObject
@synthesize object;
-(id)initWithSEL:(SEL)selector target:(id)target{
    if (self = [super init]) {
        _selectorValue = [NSValue valueWithBytes:&selector objCType:@encode(SEL)];
        _target = target;
    }
    return self;
}

-(void)performSelector{
    if (_selectorValue != NULL && [_target respondsToSelector:_selectorValue.pointerValue]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_selectorValue.pointerValue withObject:self.object];
#pragma clang diagnostic pop        
    }
}
@end

