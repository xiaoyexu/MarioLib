//
//  SALViewDelegate.h
//  SALUIDesignTest
//
//  Created by Xu, Xiaoye on 3/1/14.
//  Copyright (c) 2014 SAL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYBaseView;

@protocol XYViewDelegate <NSObject>
@optional
-(void)xyView:(XYBaseView*)view movedTo:(CGPoint)point gesture:(UIGestureRecognizer*)gest;
@end
