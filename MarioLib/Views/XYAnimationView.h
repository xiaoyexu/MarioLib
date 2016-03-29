//
//  XYAnimationView.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/29/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseView.h"
#import "XYAnimationViewDelegate.h"
#import "XYUtility.h"

/**
 XYAnimationView is a subclass of XYBaseView which has animation for appearing/disappearing
 */
@interface XYAnimationView : XYBaseView {
    @protected
    BOOL _animating;
    id<XYAnimationViewDelegate> _animationDelegate;
    NSTimeInterval _showAnimationDuration;
    NSTimeInterval _delayAnimationDuration;
    NSTimeInterval _dismissAnimationDuration;

}

/**
 Delegate for animation logic
 */
@property (nonatomic, strong) id<XYAnimationViewDelegate> animationDelegate;

/**
 Name of this view
 */
@property (nonatomic, strong) NSString* name;

/**
 Flag whether animation is on-going
 */
@property(nonatomic, readonly) BOOL animating;

/**
 NSTimeInterval for view to appear
 */
@property(nonatomic) NSTimeInterval showAnimationDuration;

/**
 NSTimeInterval for view to hold
 If value is 0, you need to call dismiss method manually
 */
@property(nonatomic) NSTimeInterval delayAnimationDuration;

/**
 NSTimeInterval for view to disappear
 */
@property(nonatomic) NSTimeInterval dismissAnimationDuration;

/**
 Display animation view on main screen
 */
-(void)show;

/**
 Display animation view with in another view
 @param view The view that holds animation view
 */
-(void)showInView:(UIView*)view;

/**
 Display animation view in view controller
 @param view controller  
 */
-(void)showInViewController:(UIViewController*)controller;
/**
 Dismiss animation view
 */
-(void)dismiss;
@end
