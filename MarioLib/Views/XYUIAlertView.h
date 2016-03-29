//
//  XYUIAlertView.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 5/15/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SAPUIColorExtension.h>
#import <QuartzCore/QuartzCore.h>
#import "UIDesighHeader.h"
#import "XYSkinManager.h"

@interface XYUIAlertView : UIAlertView
{
    int moveFactor;
    NSTimer *timer;
    CAShapeLayer *shapeLayer;
}
@property (nonatomic,strong) UIColor* backgroundColor;
@property (nonatomic,strong) UIImage* backgroundImage;

- (void)setTopColor:(UIColor*)tc middleColor:(UIColor*)mc bottomColor:(UIColor*)bc lineColor:(UIColor*)lc;
- (void)setFontName:(NSString*)fn fontColor:(UIColor*)fc fontShadowColor:(UIColor*)fsc;
- (void)setImage:(NSString*)imageName;
@end
