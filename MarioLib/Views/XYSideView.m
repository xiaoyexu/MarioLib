//
//  XYSideView.m
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/17/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSideView.h"

@implementation XYSideView
@synthesize animating = _animating;
@synthesize loadingDesc;
@synthesize readyDesc;
@synthesize releaseDesc;
@synthesize status = _status;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectZero;
        rect.origin.x = (frame.size.width * 2)/9;
        rect.origin.y = (frame.size.height - 30)/2;
        rect.size.width = frame.size.width * 4/7;
        rect.size.height = 30;
        _label = [[UILabel alloc] initWithFrame:rect];
        _label.backgroundColor = [UIColor clearColor];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_label];
        rect.origin.x = 30;
        rect.origin.y = 0;
        rect.size.width = 40;
        rect.size.height = 40;
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:rect];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_activityIndicator];
    }
    return self;
}
-(void)setAnimating:(BOOL)animating{
    if (animating) {
        [_activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    } else {
        [_activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
    }
    _animating = animating;
}

-(void)setStatus:(XYViewStatus)status{
    [_activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    _status = status;
    if (_status == XYViewStatusReadyToExecute || _status == XYViewStatusFinished){
        [_activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
        [_label performSelectorOnMainThread:@selector(setText:) withObject:self.readyDesc waitUntilDone:YES];
    } else if (_status == XYViewStatusReleaseToExecute) {
        [_activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
        [_label performSelectorOnMainThread:@selector(setText:) withObject:self.releaseDesc waitUntilDone:YES];
    } else if (_status == XYViewStatusExecuting) {
        [_activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
        [_label performSelectorOnMainThread:@selector(setText:) withObject:self.loadingDesc waitUntilDone:YES];
    }
}
-(XYViewStatus)status{
    return _status;
}

@end
