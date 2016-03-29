//
//  XYPagedView.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/23/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYPagedView.h"

@implementation XYPagedView
@synthesize scrollView = _scrollView;
@synthesize pageController = _pageController;

-(id)initWithFrame:(CGRect)frame covers:(NSArray *)covers{
    if (self = [super initWithFrame:frame]) {
        [self buildViewWith:covers];
    }
    return self;
}

-(void)buildViewWith:(NSArray *)covers{
    [_pageController removeFromSuperview];
    [_scrollView removeFromSuperview];
    [self setNeedsDisplay];
    _covers = covers;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    //_scrollView.layer.borderWidth = 0.5;
    //_scrollView.layer.borderColor = [sepBorderColor CGColor];
    for (int i = 0 ; i<[_covers count]; i++) {
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width*i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;
        
        UIView* subView = [[UIView alloc] initWithFrame:frame];
        [subView addSubview:[_covers objectAtIndex:i]];
        [_scrollView addSubview:subView];
        
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*[_covers count], _scrollView.frame.size.height);
    [self addSubview:_scrollView];
    
    float pagecontrolheight = 10;
    
    _pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height - pagecontrolheight - 10, _scrollView.frame.size.width, pagecontrolheight)];
    _pageController.numberOfPages = [_covers count];
    [_pageController setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [_pageController setPageIndicatorTintColor:[UIColor grayColor]];
//    _pageController.backgroundColor = [UIColor redColor];
    _pageController.userInteractionEnabled = NO;
//    _pageController.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_pageController];
//    self.backgroundColor = [UIColor greenColor];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger offsetLooping = 1;
    int page = floor((scrollView.contentOffset.x - pageWidth /2) / pageWidth) + offsetLooping;
    _pageController.currentPage = page % [_covers count];
}

-(void)setCovers:(NSArray*)covers{
    [self buildViewWith:covers];
}

@end
