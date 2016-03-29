//
//  XYActivityIndicatorView.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYFieldView.h"

@interface XYActivityIndicatorView : XYFieldView
@property(nonatomic,strong) UIActivityIndicatorView* indicator;
@property(nonatomic,strong) UILabel* label;
@property(nonatomic) BOOL animating;
-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset;
-(id)initWithFrame:(CGRect)frame andRatio:(float) ratio;
-(id)initWithFrame:(CGRect)frame andLeftWidth:(float)width;
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andRatio:(float) ratio;
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andLeftWidth:(float) width;
@end
