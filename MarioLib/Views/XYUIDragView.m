//
//  XYUIDragView.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 7/30/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYUIDragView.h"

@implementation XYUIDragView
{
    NSArray* _dragViews;
    NSArray* _dropAreas;
    CGRect _originalRect;
}
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _dragViews = [NSMutableArray new];
        _dropAreas = [NSMutableArray new];
    }
    return self;
}

-(void)reloadData{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    _dropAreas = [self.dataSource dropAreas];
    for (UIView* view in _dropAreas) {
        [self addSubview:view];
    }
    _dragViews = [self.dataSource dragViews];
    for (XYBaseView* view in _dragViews) {
        view.movable = YES;
        view.delegate = self;
        [self addSubview:view];
    }
}

-(void)xyView:(XYBaseView *)view movedTo:(CGPoint)point gesture:(UIGestureRecognizer *)gest{
    
    UIGestureRecognizerState s = gest.state;
    
    if (s == UIGestureRecognizerStateBegan) {
        _originalRect = view.frame;
    }
    float diff = view.frame.origin.y - _originalRect.origin.y;
    NSLog(@"diff %f",diff);
    if (diff > 30 && diff < 100) {
        UIView* sView = [view.subviews objectAtIndex:0];
        sView.alpha = 1 - diff/100.0;
        CGRect f = CGRectZero;
        f.size.width = 100 -(diff - 30);
        f.size.height = 100 -(diff - 30);
        f.origin.x = (100 - f.size.width)/2.0;
        f.origin.y = (100 - f.size.height)/2.0;
        sView.frame = f;
        
        //        if (diff < 50) {
        //            sView2.alpha = diff/100.0;
        //            f = CGRectMake(0, 0, 0, 0);
        //            f.size.width = diff;
        //            f.size.height = diff;
        //            sView2.frame = f;
        //        }
        
        
    }
    
    // Check intersects
    
    if (s == UIGestureRecognizerStateEnded) {
        BOOL intersect = NO;
        for (UIView* v in _dropAreas) {
            if (CGRectIntersectsRect(view.frame, v.frame)) {
                [self.delegate dragView:self onReleaseView:(XYBaseView*)view inView:v];
                intersect = YES;
                break;
            }
        }
        if (!intersect) {
            [self.delegate dragView:self onReleaseView:(XYBaseView*)view];
        }
    }
    
}

@end
