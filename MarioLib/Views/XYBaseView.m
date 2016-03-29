//
//  XYBaseFieldView.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseView.h"

// For development usage to show color of defined view
//#define SHOW_COLOR_TABLE_CELL
//#define SHOW_BASE_VIEW_COLOR

@implementation XYBaseView
@synthesize viewAtTopLeft = _viewAtTopLeft;
@synthesize viewAtTop = _viewAtTop;
@synthesize viewAtTopRight = _viewAtTopRight;
@synthesize viewAtLeft = _viewAtLeft;
@synthesize viewAtCenter = _viewAtCenter;
@synthesize viewAtRight = _viewAtRight;
@synthesize viewAtBottomLeft = _viewAtBottomLeft;
@synthesize viewAtBottom = _viewAtBottom;
@synthesize viewAtBottomRight = _viewAtBottomRight;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize displayMode = _displayMode;
@synthesize contentInset = _contentInset;
@synthesize movable = _movable;
//@synthesize fixedWidthForViewAtCenter = _fixedWidthForViewAtCenter;
@synthesize autoresizing = _autoresizing;
@synthesize delegate = _delegate;
@synthesize hitTestForSubView = _hitTestForSubView;

-(id)init{
    if (self = [super init]) {
        float width = [UIScreen mainScreen].bounds.size.width;
        CGRect f = CGRectMake(0.0f, 0.0f, width, 44.0f);
        self.frame = f;
        // Default contentInset
        
        if (_contentInset.left == 0.0f) {
            _contentInset.left = 10.0f;
        }
        if (_contentInset.top == 0.0f) {
            _contentInset.top = 5.0f;
        }
        if (_contentInset.right == 0.0f) {
            _contentInset.right = 10.0f;
        }
        if (_contentInset.bottom == 0.0f) {
            _contentInset.bottom = 5.0f;
        }
        [self renderBaseView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        // Default contentInset
        
        if (_contentInset.left == 0.0f) {
            _contentInset.left = 10.0f;
        }
        if (_contentInset.top == 0.0f) {
            _contentInset.top = 5.0f;
        }
        if (_contentInset.right == 0.0f) {
            _contentInset.right = 10.0f;
        }
        if (_contentInset.bottom == 0.0f) {
            _contentInset.bottom = 5.0f;
        }
        [self renderBaseView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // Default contentInset
        
        if (_contentInset.left == 0.0f) {
            _contentInset.left = 10.0f;
        }
        if (_contentInset.top == 0.0f) {
            _contentInset.top = 5.0f;
        }
        if (_contentInset.right == 0.0f) {
            _contentInset.right = 10.0f;
        }
        if (_contentInset.bottom == 0.0f) {
            _contentInset.bottom = 5.0f;
        }
        [self renderBaseView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset{
    if (self = [super initWithFrame:frame]) {
        _contentInset = contentInset;
        _originalContentInset = _contentInset;
        [self renderBaseView];
    }
    return self;
}

-(void)renderBaseView{
    _hitTestForSubView = YES;
    self.clipsToBounds = YES;
    
#ifdef SHOW_COLOR_TABLE_CELL
    self.backgroundColor = [UIColor yellowColor];
#endif
    
    _originalContentInset = _contentInset;
    
    if (_contentInset.left != 0 && _contentInset.top != 0) {
        _viewAtTopLeft = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _contentInset.left, _contentInset.top)];
        _viewAtTopLeft.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtTopLeft.backgroundColor = [UIColor redColor];
#endif
        _viewAtTopLeft.clipsToBounds = YES;
        [self addSubview:_viewAtTopLeft];
    }
    
    if (_contentInset.top != 0) {
        _viewAtTopRight = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - _contentInset.right, 0.0f, _contentInset.right, _contentInset.top)];
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtTopRight.backgroundColor = [UIColor blueColor];
#endif
        _viewAtTopRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleBottomMargin;
        _viewAtTopRight.clipsToBounds = YES;
        [self addSubview:_viewAtTopRight];
    }
    
    if (_contentInset.left != 0 && _contentInset.bottom != 0) {
        _viewAtBottomLeft = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - _contentInset.bottom, _contentInset.left, _contentInset.bottom)];
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtBottomLeft.backgroundColor = [UIColor orangeColor];
#endif
        _viewAtBottomLeft.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        _viewAtBottomLeft.clipsToBounds = YES;
        [self addSubview:_viewAtBottomLeft];
    }
    
    if (_contentInset.right != 0 && _contentInset.bottom != 0) {
        _viewAtBottomRight = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - _contentInset.right, self.frame.size.height - _contentInset.bottom, _contentInset.right, _contentInset.bottom)];
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtBottomRight.backgroundColor = [UIColor brownColor];
#endif
        _viewAtBottomRight.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        _viewAtBottomRight.clipsToBounds = YES;
        [self addSubview:_viewAtBottomRight];
    }
    
    
    
    if (_contentInset.top != 0 ) {
        _viewAtTop = [[UIView alloc] initWithFrame:CGRectMake(_contentInset.left, 0.0f, self.frame.size.width - _contentInset.left - _contentInset.right, _contentInset.top)];
        _viewAtTop.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleBottomMargin;
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtTop.backgroundColor = [UIColor greenColor];
#endif
        _viewAtTop.clipsToBounds = YES;
        [self addSubview:_viewAtTop];
    }
    
    
    if (_contentInset.left != 0) {
        _viewAtLeft = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _contentInset.top, _contentInset.left, self.frame.size.height - _contentInset.top - _contentInset.bottom)];
        _viewAtLeft.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtLeft.backgroundColor = [UIColor cyanColor];
#endif
        _viewAtLeft.clipsToBounds = YES;
        [self addSubview:_viewAtLeft];
    }
    
    if (_contentInset.right != 0) {
        _viewAtRight = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - _contentInset.right, _contentInset.top, _contentInset.right, self.frame.size.height - _contentInset.top - _contentInset.bottom)];
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtRight.backgroundColor = [UIColor magentaColor];
#endif
        _viewAtRight.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_viewAtRight];
    }
    

    
    if (_contentInset.bottom != 0) {
        _viewAtBottom = [[UIView alloc] initWithFrame:CGRectMake(_contentInset.left, self.frame.size.height - _contentInset.bottom, self.frame.size.width - _contentInset.left - _contentInset.right, _contentInset.bottom)];
        _viewAtBottom.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
#ifdef SHOW_COLOR_TABLE_CELL
        _viewAtBottom.backgroundColor = [UIColor purpleColor];
#endif
        _viewAtBottom.clipsToBounds = YES;
        [self addSubview:_viewAtBottom];
    }
    
    _viewAtCenter = [[UIView alloc] initWithFrame:CGRectMake(_contentInset.left, _contentInset.top, self.frame.size.width - _contentInset.left - _contentInset.right, self.frame.size.height - _contentInset.top - _contentInset.bottom)];
    _viewAtCenter.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
#ifdef SHOW_COLOR_TABLE_CELL
    _viewAtCenter.backgroundColor = [UIColor yellowColor];
#endif
    _viewAtCenter.clipsToBounds = YES;
    [self addSubview:_viewAtCenter];
    
    self.displayMode = XYViewDisplayModeTop | XYViewDisplayModeBottom | XYViewDisplayModeLeft | XYViewDisplayModeRight;
    
    [self bringSubviewToFront:_viewAtCenter];
}


-(void)setFrame:(CGRect)frame{
    _originalViewAtCenterFrame = _viewAtCenter.frame;
    [super setFrame:frame];
    [self reArrangeView];
}

-(void)setFrame:(CGRect)frame animation:(BOOL) animation duration:(NSTimeInterval) duration{
    BOOL original_animation = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:animation];
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    }];
    [UIView setAnimationsEnabled:original_animation];
}

-(void)setContentInset:(UIEdgeInsets)contentInset{
    _contentInset = contentInset;
    [self reArrangeView];
}

-(void)setContentInset:(UIEdgeInsets)contentInset animation:(BOOL) animation duration:(NSTimeInterval) time{
    _contentInset = contentInset;
    if (animation) {
        [UIView animateWithDuration:time animations:^{
             [self reArrangeView];
        } completion:^(BOOL finished) {

        }];
    } else {
        [self reArrangeView];
    }
    
}

-(void)setBackgroundImageView:(UIImageView *)backgroundImageView{
    if (_backgroundImageView != nil) {
        [_backgroundImageView removeFromSuperview];
        _backgroundImageView = nil;
    }
    _backgroundImageView = backgroundImageView;
    CGRect f = CGRectZero;
    f.origin = CGPointZero;
    f.size = self.frame.size;
    _backgroundImageView.frame = f;
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_backgroundImageView];
}


-(void)reArrangeView{

    UIEdgeInsets contentInset = _contentInset;
    
    float diff = 0;
    
    if ((_autoresizing & UIViewAutoresizingFlexibleLeftMargin) == UIViewAutoresizingFlexibleLeftMargin) {
        //NSLog(@"UIViewAutoresizingFlexibleLeftMargin");
        
        diff = self.frame.size.width - contentInset.left - contentInset.right - _originalViewAtCenterFrame.size.width;
        contentInset.left += diff;
        
    }
    
    if ((_autoresizing & UIViewAutoresizingFlexibleRightMargin) == UIViewAutoresizingFlexibleRightMargin) {
        diff = self.frame.size.width - contentInset.left - contentInset.right - _originalViewAtCenterFrame.size.width;
        contentInset.right += diff;
    }
        
    [self reArrangeViewWithContentInset:contentInset];

}


-(void)reArrangeViewWithContentInset:(UIEdgeInsets)insets{
    // Re-arrange the layout
    _viewAtTopLeft.frame = CGRectMake(0.0f, 0.0f, insets.left, insets.top);
    _viewAtTop.frame = CGRectMake(insets.left, 0.0f, self.frame.size.width - insets.left - insets.right, insets.top);
    _viewAtTopRight.frame = CGRectMake(self.frame.size.width - insets.right, 0.0f, insets.right, insets.top);
    _viewAtLeft.frame = CGRectMake(0.0f, insets.top, insets.left, self.frame.size.height - insets.top - insets.bottom);
    _viewAtCenter.frame = CGRectMake(insets.left, insets.top, self.frame.size.width - insets.left - insets.right, self.frame.size.height - insets.top - insets.bottom);
    _viewAtRight.frame = CGRectMake(self.frame.size.width - insets.right, insets.top, insets.right, self.frame.size.height - insets.top - insets.bottom);
    _viewAtBottomLeft.frame = CGRectMake(0.0f, self.frame.size.height - _contentInset.bottom, insets.left, insets.bottom);
    _viewAtBottom.frame = CGRectMake(insets.left, self.frame.size.height - insets.bottom, self.frame.size.width - insets.left - insets.right, insets.bottom);
    _viewAtBottomRight.frame = CGRectMake(self.frame.size.width - insets.right, self.frame.size.height - insets.bottom, insets.right, insets.bottom);
}

-(void)setDisplayMode:(XYViewDisplayMode)displayMode{
    _displayMode = displayMode;
    if ((displayMode & XYViewDisplayModeTop)) {
        _contentInset.top = _originalContentInset.top;
    } else {
        _contentInset.top = 0.0f;
    }
    
    if ((displayMode & XYViewDisplayModeBottom)) {
        _contentInset.bottom = _originalContentInset.bottom;
    } else {
        _contentInset.bottom = 0.0f;
    }

    if ((displayMode & XYViewDisplayModeLeft)) {
        _contentInset.left = _originalContentInset.left;
    } else {
        _contentInset.left = 0.0f;
    }
    
    if ((displayMode & XYViewDisplayModeRight)) {
        _contentInset.right = _originalContentInset.right;
    } else {
        _contentInset.right = 0.0f;
    }
    [self reArrangeView];
}

-(void)setMovable:(BOOL)movable{
    _movable = movable;
    if (_movable) {
        pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMoving:)];
        [self addGestureRecognizer:pgr];
    } else {
        [self removeGestureRecognizer:pgr];
        pgr = nil;
    }
    
}

-(void)handleMoving:(UIPanGestureRecognizer*)r{
    CGPoint p = [r translationInView:self.superview];
    CGRect f = self.frame;
    f.origin.x += p.x;
    f.origin.y += p.y;
    self.frame = f;
    [r setTranslation:CGPointZero inView:self.superview];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(xyView:movedTo:gesture:)]) {
        [_delegate xyView:self movedTo:p gesture:r];
    }
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (_hitTestForSubView) {
        for (UIView* subView in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subView convertPoint:point fromView:self];
            UIView* result = [subView hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
                break;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}
@end

