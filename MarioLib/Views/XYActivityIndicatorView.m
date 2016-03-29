//
//  XYActivityIndicatorView.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYActivityIndicatorView.h"

@implementation XYActivityIndicatorView
@synthesize indicator;
@synthesize label;
@synthesize animating = _animating;
-(id)init{
    if (self = [super init]) {
        // add
        [self renderActivityIndicatorView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self renderActivityIndicatorView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self renderActivityIndicatorView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset{
    if (self = [super initWithFrame:frame contentInset:contentInset]) {
        [self renderActivityIndicatorView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andRatio:(float)ratio{
    if (self = [super initWithFrame:frame andRatio:ratio]) {
        [self renderActivityIndicatorView];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andLeftWidth:(float)width{
    if (self = [super initWithFrame:frame andLeftWidth:width]) {
        [self renderActivityIndicatorView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset andRatio:(float)ratio{
    if (self = [super initWithFrame:frame contentInset:contentInset andRatio:ratio]) {
        [self renderActivityIndicatorView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset andLeftWidth:(float)width{
    if (self = [super initWithFrame:frame contentInset:contentInset andLeftWidth:width]) {
        [self renderActivityIndicatorView];
}
    return self;
}

-(void)renderActivityIndicatorView{
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect f = self.labelContainerView.frame;
    f.origin.x = self.textContainerView.frame.origin.x - 25;
    f.size.width = 10;
    [indicator setFrame:f];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    CGRect frame = CGRectZero;
    frame.size.width = self.textContainerView.frame.size.width;
    frame.size.height = self.textContainerView.frame.size.height;
    label = [[UILabel alloc] initWithFrame:frame];
    label.adjustsFontSizeToFitWidth = NO;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.autoresizingMask = UIViewAutoresizingNone;
    [self.labelContainerView addSubview:indicator];
    [self.labelContainerView bringSubviewToFront:indicator];
    [self.textContainerView addSubview:label];
    [self.textContainerView bringSubviewToFront:label];
}

-(void)setAnimating:(BOOL)animating{
    _animating = animating;
    if (_animating) {
        [indicator startAnimating];
    } else {
        [indicator stopAnimating];
    }
}

-(BOOL)animating{
    return _animating;
}

@end

