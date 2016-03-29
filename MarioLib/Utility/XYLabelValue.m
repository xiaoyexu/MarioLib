//
//  XYLabelValue.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYLabelValue.h"

@implementation XYLabelValue

@synthesize label = _label;
@synthesize value = _value;
@synthesize object = _object;

-(id)init{
    self = [super init];
    if (self != nil) {
        _label = @"";
        _value = @"";
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    XYLabelValue* newLabelValue = [[XYLabelValue alloc] init];
    newLabelValue.label = self.label;
    newLabelValue.value = self.value;
    return newLabelValue;
}

+(XYLabelValue*)labelWith:(NSString *)l value:(NSString *)v{
    XYLabelValue* newLabelValue = [XYLabelValue new];
    newLabelValue.label = l;
    newLabelValue.value = v;
    return newLabelValue;
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[XYLabelValue class]]) {
        XYLabelValue* lv = (XYLabelValue*)object;
        if ([self.label isEqualToString:lv.label] &&
            [self.value isEqualToString:lv.value]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return [super isEqual:object];
    }
}

-(NSUInteger)hash{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + self.label.hash;
    result = prime * result + self.value.hash;
    return result;
}
@end

