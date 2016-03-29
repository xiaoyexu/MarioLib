//
//  XYNotificationView.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/29/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAnimationView.h"
#import "XYUtility.h"
//#import <SAPUIColorExtension.h>
#import "XYStatusUpdateDelegate.h"

/**
 XYNotificationView is a subclass of XYAnimationView
 Which work as a notification to be displayed on the top of screen
 */
@interface XYNotificationView : XYAnimationView<XYStatusUpdateDelegate>

/**
 The title of notification
 */
@property(nonatomic,strong) NSString* title;

/**
 The message of notification
 */
@property(nonatomic,strong) NSString* message;

/**
 
 */
@property(nonatomic) CGFloat startAlpha;
@property(nonatomic) CGFloat endAlpha;

/**
 Initialization method to create a notification view
 */
-(id)initWithTitle:(NSString*) title message:(NSString *)message delegate:(id<XYAnimationViewDelegate>)delegate;

/**
 Display view on the screen
 @param view The view holds notification view
 @param b If YES, view won't reset during animation process 
 */
-(void)showInView:(UIView*)view waitUntilDone:(BOOL)b;

/**
 Display view in view controller
 @param controller View controller
 @param b If YES, view won't reset during animation process
 */
-(void)showInViewController:(UIViewController*)controller waitUntilDone:(BOOL) b;

@end
