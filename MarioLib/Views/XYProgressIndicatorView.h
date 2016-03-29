//
//  XYProgressIndicatorView.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/27/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYUtility.h"

typedef enum {
    XYProgressIndicatorColorBlue,
    XYProgressIndicatorColorRed,
    XYProgressIndicatorColorGreen,
    XYProgressIndicatorColorOrange
} XYProgressIndicatorColor;
@interface XYProgressIndicatorView : UIView

/**
 Progress value 0.0 - 1.0
 */
@property(nonatomic) float progress;

@property(nonatomic) XYProgressIndicatorColor color;
@end
