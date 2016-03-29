//
//  XYUIStatusUpdater.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUIStatusUpdater.h"

@implementation XYUIStatusUpdater
{
    id _updater;
    id<XYStatusUpdateDelegate> updateDelegate;
    NSString* originalText;
}
@synthesize updater = _updater;

-(id)initWith:(id)obj{
    self = [super init];
    if (self) {
        _updater = obj;
        if ([_updater respondsToSelector:@selector(text)]) {
            originalText = [_updater performSelector:@selector(text) withObject:nil];
        }
    }
    return self;
}

-(id)initWithDelegate:(id<XYStatusUpdateDelegate>)obj{
    if (self = [super init]) {
        updateDelegate = obj;
        originalText = @"";
    }
    return self;
}

-(void)log:(NSString*)str{
    if ([_updater respondsToSelector:@selector(setText:)]) {
        [_updater performSelectorOnMainThread:@selector(setText:) withObject:str waitUntilDone:YES];
    }
    if (updateDelegate != nil) {
        [((id)updateDelegate) performSelectorOnMainThread:@selector(log:) withObject:str waitUntilDone:YES];
    }
}

-(void)subLog:(NSString *)str{
    if ([updateDelegate respondsToSelector:@selector(subLog:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateDelegate subLog:str];
        });
    }
}

-(void)endLog{
    if ([_updater respondsToSelector:@selector(setText:)]) {
        [_updater performSelectorOnMainThread:@selector(setText:) withObject:originalText waitUntilDone:YES];
    }
    if (updateDelegate != nil) {
        [((id)updateDelegate) performSelectorOnMainThread:@selector(log:) withObject:originalText waitUntilDone:YES];
    }
    [self progress:0];
}

-(void)progress:(float)progress{
    if ([_updater respondsToSelector:@selector(setProgress:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_updater setProgress:progress];
        });
    }
    if (updateDelegate != nil) {
         [((id)updateDelegate) performSelectorOnMainThread:@selector(progress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:YES];
    }
}

-(void)subProgress:(float)progress{
    if ([updateDelegate respondsToSelector:@selector(subProgress:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [updateDelegate subProgress:[NSNumber numberWithFloat:progress]];
        });
    }
}
@end
