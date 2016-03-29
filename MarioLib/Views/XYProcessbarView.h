//
//  XYProcessbarView.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/30/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAnimationView.h"
//#import <SAPUIColorExtension.h>
#import "XYStatusUpdateDelegate.h"

/**
 XYProcessbarView is a subclass of XYAnimationView
 Which can show a title and progress bar
 */
@interface XYProcessbarView : XYAnimationView <XYStatusUpdateDelegate>

/**
 Title of view
 */
@property(nonatomic,strong) NSString* title;

/**
 Progress value
 */
@property(nonatomic) float progress;
@end
