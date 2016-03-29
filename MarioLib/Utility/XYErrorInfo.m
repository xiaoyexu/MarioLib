//
//  XYErrorInfo.m
//  XYUIDesign
//
//  Created by Xu, Xiaoye on 11/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYErrorInfo.h"

@implementation XYErrorInfo
@synthesize title = _title;
@synthesize level = _level;
@synthesize detail = _detail;
@synthesize timestamp = _timestamp;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithTitle:(NSString*)title detail:(NSString*)detail{
    if (self = [super init]) {
        _title = title;
        _detail = detail;
        _timestamp = [NSDate date];
        _level = XYErrorLevelMedium;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title detail:(NSString *)detail level:(XYErrorLevel)level{
    if (self = [super init]) {
        _title = title;
        _detail = detail;
        _timestamp = [NSDate date];
        _level = level;
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _detail = [aDecoder decodeObjectForKey:@"detail"];
        _timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
        _level = [aDecoder decodeIntForKey:@"level"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_detail forKey:@"detail"];
    [aCoder encodeObject:_timestamp forKey:@"timestamp"];
    [aCoder encodeInt:_level forKey:@"level"];
    
}

@end
