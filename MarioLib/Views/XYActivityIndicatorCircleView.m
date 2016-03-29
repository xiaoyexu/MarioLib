//
//  XYActivityIndicatorCircleView.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 7/22/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYActivityIndicatorCircleView.h"

@implementation XYActivityIndicatorCircleView
{
    CAShapeLayer* maskLayer;
    UIView* v;
}
@synthesize animating = _animating;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* circle = [[UIView alloc] initWithFrame:self.bounds];
        circle.layer.cornerRadius = frame.size.width/2.0;
        circle.backgroundColor = [UIColor yellowColor];
        [self addSubview:circle];
        
        UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(10,10,frame.size.width - 20,frame.size.height-20) cornerRadius:(frame.size.width - 20)/2.0] bezierPathByReversingPath]];
        maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        circle.layer.mask = maskLayer;
//        self.layer.mask = maskLayer;
//        self.backgroundColor = [UIColor greenColor];
        v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        v.backgroundColor = [UIColor greenColor];
        [self addSubview:v];
    }
    return self;
}

-(void)updateView{
    [UIView animateKeyframesWithDuration:1 delay:0 options:
     UIViewKeyframeAnimationOptionAutoreverse animations:^{
        
//         UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
//         [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(10,10,20,20) cornerRadius:10.0] bezierPathByReversingPath]];
//         
//         maskLayer.path = path.CGPath;
         
         // Animation
         
         v.frame = self.frame;
         
         
     } completion:^(BOOL finished) {
//         UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
//         [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(10,10,self.frame.size.width - 20,self.frame.size.height-20) cornerRadius:(self.frame.size.width - 20)/2.0] bezierPathByReversingPath]];
//         maskLayer.path = path.CGPath;
         v.frame = CGRectMake(0, 0, 10, 10);
         if (_animating) {
             [self updateView];
         }
     }];
}

-(void)startAnimating{
    _animating = YES;
    [self updateView];
    NSLog(@"start animation");
}

-(void)stopAnimating{
    _animating = NO;
    NSLog(@"stop animation");
}
@end
