//
//  XYBaseErrorCenter.m
//  XYUIDesign
//
//  Created by Xu, Xiaoye on 11/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseErrorCenter.h"


static XYBaseErrorCenter* ec;

@implementation XYBaseErrorCenter
{
    NSMutableArray* _errorQueue;
    NSString* _errorFileName;
}

@synthesize reserveErrorSize = _reserveErrorSize;

-(id)init{
    self = [super init];
    if (self != nil) {
        _errorQueue = [NSMutableArray new];
        _errorFileName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        _errorFileName = [_errorFileName stringByAppendingString:@".error"];
        _reserveErrorSize = 200;
    }
    return self;
}

+(XYBaseErrorCenter*) instance{
    if (ec == nil) {
        ec = [[XYBaseErrorCenter alloc] init];
    }
    return ec;
}

-(void)recordError:(XYErrorInfo*)errorInfo{
    NSArray* oldList = [self errorList];
    NSMutableArray* newList = [NSMutableArray arrayWithArray:oldList];
    if (!_debugMode && newList.count > _reserveErrorSize) {
        NSRange range = NSMakeRange(_reserveErrorSize,  newList.count - _reserveErrorSize);
        [newList removeObjectsInRange:range];
    }
    [newList addObject:errorInfo];
    [XYStorageManager writeArchiveData:newList toFile:_errorFileName];
}

-(void)recordErrorWithTitle:(NSString*)title detail:(NSString*)detail{
    XYErrorInfo* ei = [[XYErrorInfo alloc] initWithTitle:title detail:detail];
    [self recordError:ei];
}

-(void)recordErrorWithTitle:(NSString*)title detail:(NSString*)detail level:(XYErrorLevel)level{
    XYErrorInfo* ei = [[XYErrorInfo alloc] initWithTitle:title detail:detail level:level];
    [self recordError:ei];
}

-(void)recordDebugInfo:(NSString *)info{
    if (_debugMode) {
        XYErrorInfo* ei = [[XYErrorInfo alloc] initWithTitle:@"DEBUG" detail:info level:XYErrorLevelLow];
        [self recordError:ei];
    }
}

-(NSData*)errorListData{
    NSString* stringData = @"";
    for (XYErrorInfo* ei in [self errorList]) {
        stringData = [stringData stringByAppendingString:[NSString stringWithFormat:@"[%@](%d) <%@>\n {%@}\n",ei.timestamp,ei.level, ei.title,ei.detail]];
    }
    return [stringData dataUsingEncoding:NSUTF8StringEncoding];
}

-(void)cleanAll{
    [XYStorageManager writeArchiveData:nil toFile:_errorFileName];
}

-(NSArray*)errorList{
    NSArray* result = [XYStorageManager readArchivedDataFromFile:_errorFileName];
    
    return result;
}
@end
