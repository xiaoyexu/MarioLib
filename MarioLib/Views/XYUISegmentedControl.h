//
//  XYPagedView.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/23/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYUISegmentedControl : UISegmentedControl
@property (nonatomic, strong) UIView* selectedView;
@property (nonatomic, strong) UIView* separateView;
@property (nonatomic, strong) UIColor* selectedFontColor;
@property (nonatomic, strong) UIColor* unSelectedFontColor;
@property (nonatomic, strong) UIFont* selectedTitleFont;
@property (nonatomic, strong) UIFont* unSelectedTitleFont;
-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithItems:(NSArray *)items;
-(void)renderView;
@end
