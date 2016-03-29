//
//  XYActivityIndicator.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/23/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYActivityIndicatorIconView.h"

@implementation XYActivityIndicatorIconView
{
    UIView* spinningView;
    BOOL _animating;
}
@synthesize animating = _animating;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self renderView:frame];
    }
    return self;
}

-(void)renderView:(CGRect)frame{
    // Initialization code
    spinningView = [XYUtility sapUI5ActivityIndicatorIconWithFrame:self.bounds iconColor:[XYUtility sapBlueColor] backgroundColor:self.backgroundColor];
    spinningView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:spinningView];
}

-(void)rotateSpinningView{
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:
     //UIViewAnimationOptionRepeat |
     UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent animations:^{
         spinningView.transform = CGAffineTransformRotate(spinningView.transform, M_PI_2);
     } completion:^(BOOL finished) {
         if (_animating) {
             [self rotateSpinningView];
         }
     }];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [spinningView removeFromSuperview];
    [self renderView:frame];
}

-(void)startAnimating{
    _animating = YES;
    [self rotateSpinningView];
}

-(void)stopAnimating{
    _animating = NO;
}

@end
