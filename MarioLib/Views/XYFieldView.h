//
//  SALFieldView.h
//  SALUIDesignTest
//
//  Created by Xu Xiaoye on 6/17/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

/*
  SALFieldView provide a label/Value layout in center view named rightView and leftView
  The left side and right side divided by ratio or leftWidth given by user
 */

#import "XYBaseView.h"

typedef enum {
    XYFieldViewLayoutLabelAtLeftTextAtRight,
    XYFieldViewLayoutLabelAtTopTextAtBottom,
} XYFieldViewLayout;

@interface XYFieldView : XYBaseView
{
    float _ratio;
    float _leftWidth;
    BOOL _labelContainerViewEnabled;
    BOOL _textContainerViewEnabled;
}

// Field view layout
@property(nonatomic) XYFieldViewLayout layout;

//// View that holds label
@property(nonatomic,strong) UIView* labelContainerView;

//// View that holds text
//@property(nonatomic,strong) UIView* rightView;
@property(nonatomic,strong) UIView* textContainerView;

// Whether label view is enabled
@property(nonatomic) BOOL labelContainerViewEnabled;

// Whether text view is enabled
@property(nonatomic) BOOL textContainerViewEnabled;

// Ratio in width between left view and right view
@property(nonatomic) float ratio;

// Fixed width for left view
@property(nonatomic) float leftWidth;


// Initial the view by default, the ratio is set to 0.3
-(id)init;

-(id)initWithCoder:(NSCoder *)aDecoder;

-(id)initWithFrame:(CGRect)frame;

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset;

// Initial the view with frame and ratio of left right sub view
-(id)initWithFrame:(CGRect)frame andRatio:(float) ratio;

// Initial the view with frame and fix left width for left view
-(id)initWithFrame:(CGRect)frame andLeftWidth:(float)width;

// Initial the view with edge insets and ratio of left right sub view
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andRatio:(float) ratio;

// Initial the view with edge insets and left view width
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andLeftWidth:(float) width;
@end
