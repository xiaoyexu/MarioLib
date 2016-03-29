//
//  XYTextViewContainer.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 10/24/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBaseView.h"
#import "XYUtility.h"
#import "XYSkinManager.h"

@interface XYBubbleView : UIView
@property(nonatomic, strong) UITextView* textView;
@property(nonatomic, strong) UIImageView* backgroundImageView;
@property(nonatomic) NSTextAlignment textViewAligment;
@property(nonatomic) float paddingRight;
@property(nonatomic) float paddingLeft;
@property(nonatomic) XYBubbleCellStyle bubbleStyle;
@property(nonatomic) BOOL fromself;
@end
