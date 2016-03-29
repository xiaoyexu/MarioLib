//
//  XYNotificationView.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/29/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYNotificationView.h"

@implementation XYNotificationView
{
    UILabel* titleLabel;
    UITextView* detailText;
}

@synthesize title = _title;
@synthesize message = _message;

-(id)init{
    if (self = [super init]) {
        float width = [UIScreen mainScreen].bounds.size.width;
        CGRect f = CGRectMake(0, 0, width, 44);
        self.frame = f;
        [self renderNotificationView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect f = frame;
        f.size.height = 20;
        [self renderNotificationView];
    }
    return self;
}


-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<XYAnimationViewDelegate>)delegate{
    float width;
    // Check the width by screen width
    // The notification view always display on the top of screen
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    CGRect f = CGRectMake(0, 0, width, 44);
    if (self = [super initWithFrame:f]) {
        [self renderNotificationView];
        self.title = title;
        self.message = message;
        self.animationDelegate = delegate;
    }
    return self;
}

-(void)renderNotificationView{
    // Define the look & feel
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor lightGrayColor];
    self.viewAtLeft.backgroundColor = [UIColor orangeColor];
    titleLabel = [[UILabel alloc] initWithFrame:self.frame];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.alpha = 1;
    detailText = [[UITextView alloc] initWithFrame:self.frame];
    detailText.backgroundColor = [UIColor clearColor];
    detailText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    detailText.font = [UIFont systemFontOfSize:16];
    [self.viewAtCenter addSubview:titleLabel];
    [self.viewAtCenter addSubview:detailText];
    
    // Set default animation duration
    self.showAnimationDuration = 0.5;
    self.delayAnimationDuration = 1;
    self.dismissAnimationDuration = 0.5;
    
    self.startAlpha = 0.6;
    self.endAlpha = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)show{
    [self showInView:[XYUtility mainWindowView]];
}

-(void)showInViewController:(UIViewController*)controller{
    [self showInViewController:controller waitUntilDone:YES];
}

-(void)showInViewController:(UIViewController*)controller waitUntilDone:(BOOL) b{
    if (b && _animating) {
        return;
    }
    
    UIView* view = controller.view;
    
    if ([controller isKindOfClass:[UITableViewController class]]) {
        // If view controller is UITableViewController, add self to it's super view so that view will still there when scrolling
        
        // For ios7 above, use table view frame origin
        if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
            CGRect tableViewFrame = view.frame;
            CGRect f = self.frame;
            f.origin.x = tableViewFrame.origin.x;
            f.origin.y = tableViewFrame.origin.y;
            self.frame = f;
        }
        view.superview.clipsToBounds = YES;
        [view.superview addSubview:self];

    } else {
        if (self.superview == nil) {
            view.clipsToBounds = YES;
            [view addSubview:self];
        }
    }

    [self drawView];
}

-(void)showInView:(UIView *)view{
    [self showInView:view waitUntilDone:YES];
}

-(void)showInView:(UIView*)view waitUntilDone:(BOOL)b{
    if (b && _animating) {
        return;
    }
    if (self.superview == nil) {
        view.clipsToBounds = YES;
        [view addSubview:self];
    }
    [self drawView];
}

/**
 Logic for drawing view on screen
 */
-(void)drawView{
    // Check and calculate the title text height
    titleLabel.text = _title;
    CGRect titleFrame = CGRectZero;
    titleFrame.size = [XYUtility sizeOfText:titleLabel.text withFont:titleLabel.font constrainedSize:titleLabel.bounds.size];
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        titleFrame.size.width += 10;
    } else {
        titleFrame.size.width += 5;
    }
    
    titleLabel.frame = titleFrame;
    
    // Check and calculate the detail text height
    detailText.scrollEnabled = NO;
    detailText.text = _message;
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        detailText.contentInset = UIEdgeInsetsMake(-11, -8, 0, 0);
    } else {
        detailText.contentInset = UIEdgeInsetsMake(-11, 0, 0, 0);
    }
    
    CGRect detailFrame = CGRectZero;
    detailFrame.origin.y = titleFrame.size.height;
    detailFrame.size = [XYUtility sizeOfText:detailText.text withFont:detailText.font constrainedSize:self.viewAtCenter.frame.size];
    
    // iOS 7 strange issue
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        [detailText sizeToFit];
        detailFrame.size.height += 3;
    }
    
    detailText.frame = detailFrame;
    
    // Adjust the frame
    CGRect f = self.frame;
    f.size.height = titleFrame.size.height + detailFrame.size.height + self.contentInset.top + self.contentInset.bottom;
    self.frame = f;
    
    // Set animation start location from top
    CGRect startFrame = self.frame;
    CGRect endFrame = self.frame;
    startFrame.origin.y = -startFrame.size.height;
    self.frame = startFrame;
    if (_animationDelegate != nil) {
        [_animationDelegate animationViewWillAppear:self];
    }
    _animating = YES;
    
    // Animation start
    [UIView animateWithDuration:_showAnimationDuration animations:^{
        self.frame = endFrame;
        self.alpha = _startAlpha;
        
    } completion:^(BOOL finished) {
        if (_animationDelegate != nil) {
            [_animationDelegate animationViewDidAppear:self];
        }
        if (_delayAnimationDuration != 0) {
            [NSTimer scheduledTimerWithTimeInterval:_delayAnimationDuration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        }
    }];
}

-(void)dismiss{
    // Set animation start location from top
    CGRect oldFrame = self.frame;
    CGRect startFrame = self.frame;
    startFrame.origin.y = -startFrame.size.height;
    
    if (_animationDelegate != nil) {
        [_animationDelegate animationViewWillDisappear:self];
    }
    [UIView animateWithDuration:_dismissAnimationDuration animations:^{
        self.frame = startFrame;
        self.alpha = _endAlpha;
    } completion:^(BOOL finished) {
        self.frame = oldFrame;
        
        _animating = NO;
        if (_animationDelegate != nil) {
            [_animationDelegate animationViewDidDisappear:self];
        }
        [self removeFromSuperview];
    }];
}

-(void)log:(NSString *)status{
    _title = status;
    titleLabel.text = _title;
    CGRect titleFrame = titleLabel.frame;
    CGSize s = [XYUtility sizeOfText:titleLabel.text withFont:titleLabel.font constrainedSize:self.bounds.size];
    titleFrame.size.width = MAX(s.width,titleFrame.size.width);
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        titleFrame.size.width += 10;
    } else {
        titleFrame.size.width += 5;
    }
    titleLabel.frame = titleFrame;
}

-(void)progress:(NSNumber *)progress{
    
}

@end
