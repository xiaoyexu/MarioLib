//
//  SALBaseFieldView.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDesighHeader.h"
#import <QuartzCore/QuartzCore.h>
#import "XYSelectorObject.h"
#import "XYViewDelegate.h"

/**
 If SALBaseView is used in table view with SALBaseUITableViewDelegate, set autoresizingMask to UIViewAutoresizingNone so that width will be controlled by delegate.
 */

@interface XYBaseView :UIView
{
    @protected
    // Edge inset of this view
    UIEdgeInsets _contentInset;
    
    // A copy of edge inset for enable/disable top/bottom/left/right view
    UIEdgeInsets _originalContentInset;
    
    // 9 subviews for each SALBaseView
    UIView* _viewAtTopLeft;
    UIView* _viewAtTop;
    UIView* _viewAtTopRight;
    UIView* _viewAtLeft;
    UIView* _viewAtCenter;
    UIView* _viewAtRight;
    UIView* _viewAtBottomLeft;
    UIView* _viewAtBottom;
    UIView* _viewAtBottomRight;
    
    UIPanGestureRecognizer* pgr;
    
    CGRect _originalViewAtCenterFrame;
}
@property(nonatomic,readonly) UIView* viewAtTopLeft;
@property(nonatomic,readonly) UIView* viewAtTop;
@property(nonatomic,readonly) UIView* viewAtTopRight;
@property(nonatomic,readonly) UIView* viewAtLeft;
@property(nonatomic,readonly) UIView* viewAtCenter;
@property(nonatomic,readonly) UIView* viewAtRight;
@property(nonatomic,readonly) UIView* viewAtBottomLeft;
@property(nonatomic,readonly) UIView* viewAtBottom;
@property(nonatomic,readonly) UIView* viewAtBottomRight;
@property(nonatomic,strong) UIImageView* backgroundImageView;
// Display mode for customizing
@property(nonatomic) XYViewDisplayMode displayMode;
@property(nonatomic, readonly) UIEdgeInsets contentInset;
@property(nonatomic) BOOL movable;

//// Indicator whether width fixed for view at center
//@property(nonatomic) BOOL fixedWidthForViewAtCenter;
@property(nonatomic) UIViewAutoresizing autoresizing;

@property(nonatomic) BOOL hitTestForSubView;

// View delegate
@property(nonatomic, strong) id<XYViewDelegate> delegate;

// Initial the view with screen width and height of 44
-(id)init;

// Initial method from storyboard
-(id)initWithCoder:(NSCoder *)aDecoder;

// Initial the view with given frame
-(id)initWithFrame:(CGRect)frame;

// Initial the view with frame and content insets
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset;

-(void)setContentInset:(UIEdgeInsets)contentInset;

-(void)setContentInset:(UIEdgeInsets)contentInset animation:(BOOL) animation duration:(NSTimeInterval) time;
/*
  Method for arranging view based on new frame
  The method will be called each time self.frame changes
 */ 
-(void)reArrangeView;

-(void)setFrame:(CGRect)frame animation:(BOOL) animation duration:(NSTimeInterval) duration;

@end

