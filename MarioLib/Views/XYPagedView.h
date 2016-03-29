//
//  XYPagedView.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/23/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPagedView : UIView<UIScrollViewDelegate>
{
    NSArray* _covers;
    UIPageControl* _pageController;
    UIScrollView* _scrollView;
}
@property (nonatomic,readonly) UIScrollView* scrollView;
@property (nonatomic,readonly) UIPageControl* pageController;

-(id)initWithFrame:(CGRect)frame covers:(NSArray*)covers;
-(void)setCovers:(NSArray*)covers;
@end
