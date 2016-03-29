//
//  XYActivityIndicatorBarView.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 7/21/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYActivityIndicatorBarView.h"

@implementation XYActivityIndicatorBarView
{
    UIView* barView;
    UIView* barView2;
    
    BOOL _animating;
    CAGradientLayer* _gradient;
    CAGradientLayer* _gradient2;
    int inc;
    NSMutableArray* _colors;
}
@synthesize animating = _animating;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        inc = 0;
        barView = [[UIView alloc] initWithFrame:self.bounds];
        barView2 = [[UIView alloc] initWithFrame:CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        // Background color and shape
        _gradient = [CAGradientLayer layer];
        _gradient.frame = barView.bounds;
        
        _colors = [NSMutableArray arrayWithObjects:
                   (id)[UIColor colorWithRed:45.0/255 green:180.0/255 blue:233.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:29.0/255 green:109.0/255 blue:200.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:38.0/255 green:97.0/255 blue:185.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:29.0/255 green:109.0/255 blue:200.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:45.0/255 green:180.0/255 blue:233.0/255 alpha:1].CGColor,
                   //                   (id)[UIColor greenColor].CGColor,
                   //                   (id)[UIColor redColor].CGColor,
                   //                   (id)[UIColor blueColor].CGColor,
                   //                   (id)[UIColor redColor].CGColor,
                   //                   (id)[UIColor greenColor].CGColor,
                   nil
                   ];
        _gradient.colors = _colors;
        _gradient.startPoint = CGPointMake(0, 0);
        _gradient.endPoint = CGPointMake(1, 0);
        _gradient.locations = @[@(1/6.0),
                                @(2/6.0),
                                @(3/6.0),
                                @(4/6.0),
                                @(5/6.0)
                                ];
        [barView.layer insertSublayer:_gradient atIndex:0];
        barView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:barView];
        
        _gradient2 = [CAGradientLayer layer];
        _gradient2.frame = barView2.bounds;
        
        //        _colors = [NSMutableArray arrayWithObjects:
        //                   (id)[UIColor colorWithRed:45.0/255 green:180.0/255 blue:233.0/255 alpha:1].CGColor,
        //                   (id)[UIColor colorWithRed:29.0/255 green:109.0/255 blue:200.0/255 alpha:1].CGColor,
        //                   (id)[UIColor colorWithRed:38.0/255 green:97.0/255 blue:185.0/255 alpha:1].CGColor,
        //                   (id)[UIColor colorWithRed:29.0/255 green:109.0/255 blue:200.0/255 alpha:1].CGColor,
        //                   (id)[UIColor colorWithRed:45.0/255 green:180.0/255 blue:233.0/255 alpha:1].CGColor,
        //                   nil
        //                   ];
        _colors = [NSMutableArray arrayWithObjects:
                   (id)[UIColor colorWithRed:45.0/255 green:180.0/255 blue:233.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:29.0/255 green:109.0/255 blue:200.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:38.0/255 green:97.0/255 blue:185.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:29.0/255 green:109.0/255 blue:200.0/255 alpha:1].CGColor,
                   (id)[UIColor colorWithRed:45.0/255 green:180.0/255 blue:233.0/255 alpha:1].CGColor,
                   nil
                   ];
        _gradient2.colors = _colors;
        _gradient2.startPoint = CGPointMake(0, 0);
        _gradient2.endPoint = CGPointMake(1, 0);
        _gradient2.locations = @[@(1/6.0),
                                 @(2/6.0),
                                 @(3/6.0),
                                 @(4/6.0),
                                 @(5/6.0)
                                 ];
        [barView2.layer insertSublayer:_gradient2 atIndex:0];
        barView2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:barView2];
        
    }
    return self;
}
-(void)updateGradientLocationView{
    
    [UIView animateKeyframesWithDuration:1 delay:0 options:
     UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
         CGRect f = barView.frame;
         if (f.origin.x == self.frame.size.width) {
             f.origin.x = 0;
             barView.frame = f;
         }
         
         f.origin.x += barView.bounds.size.width;
         barView.frame = f;
         f = barView2.frame;
         if (f.origin.x == 0) {
             f.origin.x = - f.size.width;
             barView2.frame = f;
         }
         f.origin.x += barView2.bounds.size.width;
         barView2.frame = f;
         
     } completion:^(BOOL finished) {
         if (_animating) {
             [self updateGradientLocationView];
         }
     }];
    
    
    //    [UIView animateKeyframesWithDuration:0.3 delay:0 options:
    //     UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent animations:^{
    //         inc = ++inc % 50;
    //         if (inc == 0) {
    //             [_colors insertObject:[_colors objectAtIndex:3] atIndex:0];
    //             [_colors removeObjectAtIndex:4];
    //         }
    ////         [_colors addObject:[_colors objectAtIndex:0]];
    ////         [_colors removeObjectAtIndex:0];
    //
    ////         [_colors insertObject:[_colors objectAtIndex:2] atIndex:0];
    ////         [_colors removeObjectAtIndex:3];
    //
    ////         [_gradient removeFromSuperlayer];
    ////         sleep(1);
    //         NSLog(@"%d",inc);
    ////         NSLog(@"%d %@",inc, _colors);
    ////         _gradient = [CAGradientLayer layer];
    //         _gradient.colors = _colors;
    ////         _gradient.startPoint = CGPointMake(0, 0);
    ////         _gradient.endPoint = CGPointMake(1, 0);
    ////         _gradient.locations = @[@(1/6.0),@(2/6.0),@(3/6.0),@(4/6.0),@(5/6.0)];
    //         float d = inc/250.0;
    //         _gradient.locations = @[@(1/5.0+d),@(2/5.0+d),@(3/5.0+d),@(4/5.0+d)];
    //         NSLog(@"%@", _gradient.locations);
    //
    ////         _gradient.locations = @[@(inc/60.0),@((2*inc)%60/60.0),@((3*inc)%60/60.0),@((4*inc)%60/60.0),@((5*inc)%60/60.0)];
    //
    //         [NSThread sleepForTimeInterval:0.1];
    //
    ////         [barView.layer insertSublayer:_gradient atIndex:0];
    //     } completion:^(BOOL finished) {
    //         if (_animating) {
    //             [self updateGradientLocationView];
    //         }
    //     }];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [barView removeFromSuperview];
    barView = [[UIView alloc] initWithFrame:self.bounds];
    [barView.layer insertSublayer:_gradient atIndex:0];
    barView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:barView];
}

-(void)startAnimating{
    _animating = YES;
    [self updateGradientLocationView];
}

-(void)stopAnimating{
    _animating = NO;
}
@end
