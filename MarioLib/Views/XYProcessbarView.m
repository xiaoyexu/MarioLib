//
//  XYProcessbarView.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/30/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYProcessbarView.h"

@implementation XYProcessbarView
{
    UILabel* titleLabel;
    UIProgressView* progressView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor lightGrayColor];
        self.viewAtLeft.backgroundColor = [UIColor orangeColor];
        CGRect f = self.viewAtCenter.frame;
        f.origin = CGPointZero;
        f.size.height /= 2;
        titleLabel = [[UILabel alloc] initWithFrame:f];
        titleLabel.backgroundColor = [UIColor clearColor];
        f.origin.y = f.size.height;
        progressView = [[UIProgressView alloc] initWithFrame:f];
        progressView.backgroundColor = [UIColor clearColor];
        [self.viewAtCenter addSubview:titleLabel];
        [self.viewAtCenter addSubview:progressView];
        self.showAnimationDuration = 1;
        self.delayAnimationDuration = 0;
        self.dismissAnimationDuration = 1;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setTitle:(NSString *)title{
    titleLabel.text = title;
}

-(NSString*)title{
    return titleLabel.text;
}

-(void)setProgress:(float)progress{
    progressView.progress = progress;
}

-(float)progress{
    return progressView.progress;
}

-(void)showInView:(UIView *)view{
    [super showInView:view];
    
    // Animation
    CGRect startFrame = self.frame;
    CGRect endFrame = self.frame;
    startFrame.origin.y = -startFrame.size.height;
    //startFrame.origin.y = 0;
    self.frame = startFrame;
    _animating = YES;
    if (_animationDelegate != nil) {
        [_animationDelegate animationViewWillAppear:self];
    }
    
    [UIView animateWithDuration:_showAnimationDuration animations:^{
        self.frame = endFrame;
        self.alpha = 0.7;
        
    } completion:^(BOOL finished) {
        _animating = NO;
        if (_animationDelegate != nil) {
            [_animationDelegate animationViewDidAppear:self];
        }
        
    }];
}

-(void)dismiss{
    CGRect oldFrame = self.frame;
//    NSLog(@"%f,%f,%f,%f",oldFrame.origin.x, oldFrame.origin.y,oldFrame.size.width,oldFrame.size.height);
    CGRect startFrame = self.frame;
    CGRect endFrame = self.frame;
    endFrame.origin.y = -endFrame.size.height;
    //startFrame.origin.y = 0;
    self.frame = startFrame;
    _animating = YES;
    if (_animationDelegate != nil) {
        [_animationDelegate animationViewWillDisappear:self];
    }
    [UIView animateWithDuration:_dismissAnimationDuration animations:^{
        self.frame = endFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        _animating = NO;
        self.frame = oldFrame;
        [self removeFromSuperview];
        if (_animationDelegate != nil) {
            [_animationDelegate animationViewDidDisappear:self];
        }
    }];
}

-(void)log:(NSString *)status{
    self.title = status;
}

-(void)progress:(NSNumber*)progress{
    [progressView setProgress:progress.floatValue animated:YES];
}


@end
