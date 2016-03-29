//
//  XYAnimationView.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 8/29/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAnimationView.h"

@implementation XYAnimationView
@synthesize animationDelegate = _animationDelegate;
@synthesize name = _name;
@synthesize animating = _animating;
@synthesize showAnimationDuration = _showAnimationDuration;
@synthesize delayAnimationDuration = _delayAnimationDuration;
@synthesize dismissAnimationDuration = _dismissAnimationDuration;
@synthesize movable = _movable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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

-(void)show{
    UIView* screenView = [XYUtility mainWindowView];
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    [screenView addSubview:self];
}

-(void)showInView:(UIView*)view{
    // If view is displayed remove it first
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    
    // Animation block
    [view addSubview:self];
}

-(void)showInViewController:(UIViewController *)controller{
    [self showInView:controller.view];
}

-(void)dismiss{
    
    // Animation block
    
    [self removeFromSuperview];
}

// De-alloc the object and remove it from super view
-(void)dealloc{
    [self removeFromSuperview];
}
@end
