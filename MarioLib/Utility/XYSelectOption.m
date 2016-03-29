//
//  XYSelectOption.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectOption.h"

@implementation XYSelectOption
@synthesize sign = _sign;
//@synthesize signText = _signText;
@synthesize option = _option;
//@synthesize optionText = _optionText;
@synthesize lowValue = _lowValue;
@synthesize highValue = _highValue;
-(id)initWithSign:(NSString*)sign option:(NSString*) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue{
    if (self = [super init]) {
        _sign = sign;
        _option = option;
        _lowValue = lowValue;
        _highValue = highValue;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.sign = [aDecoder decodeObjectForKey:@"sign"];
        self.option = [aDecoder decodeObjectForKey:@"option"];
        self.lowValue = [aDecoder decodeObjectForKey:@"lowValue"];
        self.highValue = [aDecoder decodeObjectForKey:@"highValue"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.sign forKey:@"sign"];
    [aCoder encodeObject:self.option forKey:@"option"];
    [aCoder encodeObject:self.lowValue forKey:@"lowValue"];
    [aCoder encodeObject:self.highValue forKey:@"highValue"];
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[XYSelectOption class]]) {
        XYSelectOption* so = (XYSelectOption*)object;
        if ([self.sign isEqualToString:so.sign] && [self.option isEqualToString:so.option] && [self.lowValue isEqualToString:so.lowValue] && [self.highValue isEqualToString:so.highValue] ) {
            return YES;
        } else {
            return NO;
        }
    }
    return [self isEqual:object];
}

-(NSUInteger)hash{
    return self.sign.hash + self.option.hash * 2 + self.lowValue.hash * 3 + self.highValue.hash * 4;
}
@end
