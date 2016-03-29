//
//  XYFieldSelectOption.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYFieldSelectOption.h"

@implementation XYFieldSelectOption
@synthesize property = _property;
@synthesize selectOptions = _selectOptions;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithProperty:(NSString*) property andSelectOption:(XYSelectOption*)option{
    if (self = [super init]) {
        _property = property;
        _selectOptions = [NSMutableSet setWithObject:option];
    }
    return self;
}

-(id)initWithProperty:(NSString*) property andSelectOptionSign:(NSString*)sign option:(NSString*) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue{
    if (self = [super init]) {
        _property = property;
        XYSelectOption* so = [[XYSelectOption alloc] initWithSign:sign option:option lowValue:lowValue highValue:highValue];
        _selectOptions = [NSMutableSet setWithObject:so];
    }
    return self;
}

-(id)initWithProperty:(NSString*) property andSelectOptionSet:(NSSet*)options{
    if (self = [super init]) {
        _property = property;
        _selectOptions = [NSMutableSet setWithSet:options];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.property = [aDecoder decodeObjectForKey:@"property"];
        self.selectOptions = [aDecoder decodeObjectForKey:@"selectOptions"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.property forKey:@"property"];
    [aCoder encodeObject:self.selectOptions forKey:@"selectOptions"];
}

-(void)addSelectOption:(XYSelectOption*)so{
    if (_selectOptions == nil) {
        _selectOptions = [NSMutableSet new];
    }
    [_selectOptions addObject:so];
}

-(void)setSingleSelectOption:(XYSelectOption*)so{
    _selectOptions = [NSMutableSet setWithObject:so];
}

-(void)removeSelectOption:(XYSelectOption*)so{
    [_selectOptions removeObject:so];
}

-(void)clearSelectOption{
    [_selectOptions removeAllObjects];
}
@end
