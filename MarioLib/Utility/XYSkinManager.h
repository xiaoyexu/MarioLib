//
//  XYSkinManager.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/16/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <SAPTitleLabel.h>
#import "XYUtility.h"

typedef enum {
    XYSkinStyleDefault = 0,
    XYSkinStyleUI5 = 1,
} XYSkinStyle;


@interface XYSkinManager : NSObject

/**
 Bar background color, only available for iOS 7 above
 */
@property(nonatomic, strong) UIColor* navigationBarBarTintColor;

/**
 Bar style
 */
@property(nonatomic) UIBarStyle navigationBarBarStyle;

/**
 Bar title font
 */
@property(nonatomic, strong) UIFont* navigationBarTitleFont;

/**
 Bar title color
 */
@property(nonatomic, strong) UIColor* navigationBarTitleColor;

/**
 Bar button text color
 */
@property(nonatomic, strong) UIColor* navigationBarTintColor;

/**
 Colr of extra line at the bottom of navigation bar
 */
@property(nonatomic, strong) UIColor* navigationBarBottomLineColor;

@property(nonatomic, strong) UIColor* xyButtonTableCellTextColor;
@property(nonatomic, strong) UIColor* xyButtonTableCellBackgroundColor;
@property(nonatomic, strong) UIColor* xyClearButtonTableCellTextColor;
@property(nonatomic, strong) UIColor* xyClearButtonTableCellBackgroundColor;

@property(nonatomic) UIBarStyle xyDynFieldSearchBarStyle;
@property(nonatomic, strong) UIColor* xyDynFieldSearchBarBackgroundColor;
@property(nonatomic, strong) UIColor* xyDynFieldSearchBarTintColor;

@property(nonatomic) UIBarStyle xyPickerFieldBarStyle;

/**
 Message input bar background image in bubble view
 */
@property(nonatomic, strong) UIImage* xyBubbleViewMessageInputBarBackground;

/**
 Message input field background image in bubble view
 */
@property(nonatomic, strong) UIImage* xyBubbleViewMessageInputFieldBackground;

/**
 Message send button background image in bubble view
 */
@property(nonatomic, strong) UIImage* xyBubbleViewMessageSendButtonBackground;

/**
 Message send button highlighted image in bubble view
 */
@property(nonatomic, strong) UIImage* xyBubbleViewMessageSendButtonHighlighted;

/**
 Send button color if no image provided
 */
@property(nonatomic, strong) UIColor* xyBubbleViewMessageSendButtonColor;
@property(nonatomic, strong) UIColor* xyBubbleViewBackgroundColor;
@property(nonatomic, strong) UIView* xyBubbleViewBackgroundView;
@property(nonatomic) XYBubbleCellStyle xyBubbleViewCellStyle;
@property(nonatomic) XYAlertViewStyle xyAlertViewStyle;
@property(nonatomic, strong) UIColor* xyTableCellLabelColor;
@property(nonatomic, strong) UIColor* xyTableCellTextColor;
@property(nonatomic, strong) UIColor* xyDynSearchSelectionFieldSegmentControlBackgroundColor;
@property(nonatomic, strong) UIColor* xyDynSearchSelectionFieldSegmentControlTintColor;
@property(nonatomic, strong) UIColor* favoriteCustomerViewBadgeFillColor;
@property(nonatomic, strong) UIColor* favoriteCustomerViewBadgeStrokeColor;
@property(nonatomic) CGFloat favoriteCustomerViewBadgeStrokeWidth;
@property(nonatomic, strong) UIColor* favoriteCustomerViewBadgeTextColor;
@property(nonatomic) BOOL favoriteCustomerViewBadgeShadow;
/**
 Sytle setting
 XYSkinStyleUI5 only works for iOS 7.0 and above
 */
@property(nonatomic) XYSkinStyle style;
+(XYSkinManager*)instance;
@end
