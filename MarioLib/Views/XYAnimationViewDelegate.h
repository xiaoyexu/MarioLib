//
//  XYAnimationViewDelegate.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/29/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAnimationView.h"
@class XYAnimationView;

/**
 Delegate protocol for animations
 */
@protocol XYAnimationViewDelegate <NSObject>

@optional
/**
 Delegate protocol for animations will appear
 @param view XYAnimationView instance
 */
-(void)animationViewWillAppear:(XYAnimationView*)view;

/**
 Delegate protocol for animations did appear
 @param view XYAnimationView instance
 */
-(void)animationViewDidAppear:(XYAnimationView*)view;

/**
 Delegate protocol for animations will disappear
 @param view XYAnimationView instance
 */
-(void)animationViewWillDisappear:(XYAnimationView*)view;

/**
 Delegate protocol for animations did disappear
 @param view XYAnimationView instance
 */
-(void)animationViewDidDisappear:(XYAnimationView*)view;

/**
 Delegate protocol for animation view event
 @param view XYAnimationView instance
 @param controlEvent UIControlEvents data
 */
-(void)animationView:(XYAnimationView*)view event:(UIControlEvents)controlEvent;
@end
