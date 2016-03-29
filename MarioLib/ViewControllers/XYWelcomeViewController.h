//
//  XYWelcomeViewController.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/3/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XYUIDesign.h"
#import "UIDesighHeader.h"
@class XYWelcomeViewController;

@protocol XYWelcomeViewDelegate <NSObject>
@optional
-(void)didExitWelcomeView:(XYWelcomeViewController*)wc;
@end

@interface XYWelcomeViewController : UIViewController
@property (nonatomic,strong) id<XYWelcomeViewDelegate> delegate;
/**
 
 */
-(void)enterAppAction;
@end
