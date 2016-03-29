//
//  XYKeyboardListener.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 12/17/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYKeyboardListener.h"

@implementation XYKeyboardListener
@synthesize visible = _visible;

+(XYKeyboardListener*)instance{
    static XYKeyboardListener* instance;
    if (instance == nil) {
        instance = [[XYKeyboardListener alloc] init];
    }
    return instance;
}

-(id)init{
    if (self = [super init]) {
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardDisplayed:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDisappeared:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

-(void)keyboardDisplayed:(NSNotification*)notif{
    _visible = YES;
}

-(void)keyboardDisappeared:(NSNotification*)notif{
    _visible = NO;
}

-(BOOL)visible{
    return _visible;
}
@end
