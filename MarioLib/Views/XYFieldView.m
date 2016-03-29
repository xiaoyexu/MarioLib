//
//  XYFieldView.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 6/17/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYFieldView.h"

//#define SHOW_BASE_VIEW_COLOR

@implementation XYFieldView
@synthesize layout = _layout;
@synthesize labelContainerView = _labelContainerView;
@synthesize textContainerView = _textContainerView;
@synthesize ratio = _ratio;
@synthesize leftWidth = _leftWidth;
@synthesize labelContainerViewEnabled = _labelContainerViewEnabled;
@synthesize textContainerViewEnabled = _textContainerViewEnabled;

-(id)init{
    if (self = [super init]) {
        _ratio = 0.3f;
        [self renderFieldView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        _ratio = 0.3;
        [self renderFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ratio = 0.3f;
        [self renderFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset{
    if (self = [super initWithFrame:frame contentInset:contentInset]) {
        _ratio = 0.3f;
        [self renderFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andRatio:(float)ratio{
    if (self = [super initWithFrame:frame]) {
        _ratio = ratio;
        [self renderFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andLeftWidth:(float)width{
    if (self = [super initWithFrame:frame]) {
        _leftWidth = width;
        [self renderFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andRatio:(float) ratio{
    if (self = [super initWithFrame:frame contentInset:contentInset]) {
        _contentInset = contentInset;
        _originalContentInset = _contentInset;
        _ratio = ratio;
        [self renderFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andLeftWidth:(float) width{
    if (self = [super initWithFrame:frame contentInset:contentInset]) {
        _contentInset = contentInset;
        _originalContentInset = _contentInset;
        _leftWidth = width;
        [self renderFieldView];
    }
    return self;
}

-(void)renderFieldView{
    CGRect frame = CGRectMake(_contentInset.left, _contentInset.top, self.frame.size.width - _contentInset.left - _contentInset.right,self.frame.size.height - _contentInset.top - _contentInset.bottom);
    
    // Show both view by default
    _labelContainerViewEnabled = YES;
    _textContainerViewEnabled = YES;
    
    // Set masking and subview clips to bounds
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.clipsToBounds = YES;
    float leftWidth;
    
    // If ratio is provided use ratio, otherwise use given width of left view
    if (_ratio != 0) {
        leftWidth = floor(frame.size.width * _ratio);
    } else {
        leftWidth = _leftWidth;
    }

    _labelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWidth, frame.size.height)];
#ifdef SHOW_BASE_VIEW_COLOR
    _labelContainerView.backgroundColor = [UIColor yellowColor];
#endif
    _labelContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textContainerView = [[UIView alloc] initWithFrame:CGRectMake(leftWidth+5, 0, frame.size.width - leftWidth-5, frame.size.height)];
    
    _textContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
#ifdef SHOW_BASE_VIEW_COLOR
    _textContainerView.backgroundColor = [UIColor redColor];
#endif
    _labelContainerView.clipsToBounds = YES;
    _textContainerView.clipsToBounds = YES;
    
    [self.viewAtCenter addSubview:_labelContainerView];
    [self.viewAtCenter addSubview:_textContainerView];
}


-(void)reArrangeView{
    [super reArrangeView];

    // Rearrange view based on layout
    switch (_layout) {
        /*
          style left to right
          Label | Text
         */
        case XYFieldViewLayoutLabelAtLeftTextAtRight:{
            CGRect centerFrame = CGRectMake(_contentInset.left, _contentInset.top, self.frame.size.width - _contentInset.left - _contentInset.right,self.frame.size.height - _contentInset.top - _contentInset.bottom);
            
            float leftWidth;
            if (_ratio != 0) {
                leftWidth = floor(centerFrame.size.width * _ratio);
            } else {
                leftWidth = _leftWidth;
            }
            CGRect leftRect = CGRectZero;
            if (_labelContainerViewEnabled) {
                leftRect = CGRectMake(0, 0, leftWidth, centerFrame.size.height);
                
            } else {
                leftRect = CGRectMake(0, 0, 0, centerFrame.size.height);
            }
            
            [_labelContainerView setFrame:leftRect];
            // Add 5 pixel between left view and right view
            CGRect rightRect = CGRectZero;
            if (_textContainerViewEnabled) {
                float x = leftRect.size.width == 0 ? 0 : leftRect.size.width + 5;
                float width = leftRect.size.width == 0 ? centerFrame.size.width : centerFrame.size.width - leftRect.size.width - 5;
                rightRect = CGRectMake(x, 0, width, centerFrame.size.height);
            } else {
                rightRect = CGRectMake(leftRect.size.width, 0, 0, centerFrame.size.height);
            }
            [_textContainerView setFrame:rightRect];
        }
            
            break;
        /*
          Sytle top to bottom
          Lable
          ----
          Text
         */
        case XYFieldViewLayoutLabelAtTopTextAtBottom:{
            CGRect centerFrame = CGRectMake(_contentInset.left, _contentInset.top, self.frame.size.width - _contentInset.left - _contentInset.right,self.frame.size.height - _contentInset.top - _contentInset.bottom);
            
            float leftWidth;
            if (_ratio != 0) {
                leftWidth = floor(centerFrame.size.height * _ratio);
            } else {
                leftWidth = _leftWidth;
            }
            CGRect leftRect = CGRectZero;
            if (_labelContainerView) {
                // Since the label will be displayed on the top, the height is fixed as 34
                leftRect = CGRectMake(0, 0, centerFrame.size.width, 34);
                
            } else {
                leftRect = CGRectMake(0, 0, centerFrame.size.width,0);
            }
            
            [_labelContainerView setFrame:leftRect];
            // Add 5 pixel between left view and right view
            CGRect rightRect = CGRectZero;
            if (_textContainerViewEnabled) {
                float x = leftRect.size.height == 0 ? 0 : leftRect.size.height;
                float height = leftRect.size.height == 0 ? centerFrame.size.height : centerFrame.size.height - leftRect.size.height;
                rightRect = CGRectMake(0, x, centerFrame.size.width, height);
            } else {
                rightRect = CGRectMake(0, leftRect.size.height, centerFrame.size.width, 0);
            }
            [_textContainerView setFrame:rightRect];
            
        }
            break;
        default:
            break;
    }
}

// The sub class need to implement this method to render the layout
-(void)setLayout:(XYFieldViewLayout)layout{
    _layout = layout;
    //[self reArrangeView];
    switch (layout) {
        case XYFieldViewLayoutLabelAtLeftTextAtRight:{
            
        }
            break;
         
        case XYFieldViewLayoutLabelAtTopTextAtBottom:{
    
        }
            break;
        default:
            break;
    }
}

@end
