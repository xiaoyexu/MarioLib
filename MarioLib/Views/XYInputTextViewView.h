//
//  XYInputTextViewView.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYFieldView.h"
#import "XYUtility.h"

@interface XYInputTextViewView : XYFieldView
@property(nonatomic,strong) UILabel* label;
@property(nonatomic,strong) UITextView* textView;
@property(nonatomic) BOOL stickToTextView;

// Indicate text view alignment, valid value NSTextAlignmentLeft  NSTextAlignmentCenter NSTextAlignmentRight
// Only work in iOS 7
@property(nonatomic) NSTextAlignment textViewAligment;

@property(nonatomic, readonly) CGSize textSize;
-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset;
-(id)initWithFrame:(CGRect)frame andRatio:(float) ratio;
-(id)initWithFrame:(CGRect)frame andLeftWidth:(float)width;
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andRatio:(float) ratio;
-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andLeftWidth:(float) width;
@end