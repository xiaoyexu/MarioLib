//
//  XYSkinManager.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/16/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYSkinManager.h"


XYSkinManager* _instance;

@implementation XYSkinManager
@synthesize navigationBarBarTintColor = _navigationBarBarTintColor;
@synthesize navigationBarBarStyle = _navigationBarBarStyle;
@synthesize navigationBarTitleFont = _navigationBarTitleFont;
@synthesize navigationBarTitleColor = _navigationBarTitleColor;
@synthesize navigationBarTintColor = _navigationBarTintColor;
@synthesize navigationBarBottomLineColor = _navigationBarBottomLineColor;
@synthesize xyButtonTableCellTextColor = _xyButtonTableCellTextColor;
@synthesize xyButtonTableCellBackgroundColor = _xyButtonTableCellBackgroundColor;
@synthesize xyClearButtonTableCellTextColor = _xyClearButtonTableCellTextColor;
@synthesize xyClearButtonTableCellBackgroundColor = _xyClearButtonTableCellBackgroundColor;
@synthesize xyDynFieldSearchBarStyle = _xyDynFieldSearchBarStyle;
@synthesize xyDynFieldSearchBarBackgroundColor = _xyDynFieldSearchBarBackgroundColor;
@synthesize xyPickerFieldBarStyle = _xyPickerFieldBarStyle;
@synthesize xyBubbleViewMessageInputBarBackground = _xyBubbleViewMessageInputBarBackground;
@synthesize xyBubbleViewMessageInputFieldBackground = _xyBubbleViewMessageInputFieldBackground;
@synthesize xyBubbleViewMessageSendButtonBackground = _xyBubbleViewMessageSendButtonBackground;
@synthesize xyBubbleViewMessageSendButtonHighlighted = _xyBubbleViewMessageSendButtonHighlighted;
@synthesize xyBubbleViewMessageSendButtonColor = _xyBubbleViewMessageSendButtonColor;
@synthesize xyBubbleViewBackgroundColor = _xyBubbleViewBackgroundColor;
@synthesize xyBubbleViewBackgroundView = _xyBubbleViewBackgroundView;
@synthesize xyBubbleViewCellStyle = _xyBubbleViewCellStyle;
@synthesize xyAlertViewStyle = _xyAlertViewStyle;
@synthesize xyTableCellLabelColor = _xyTableCellLabelColor;
@synthesize xyTableCellTextColor = _xyTableCellTextColor;
@synthesize xyDynSearchSelectionFieldSegmentControlBackgroundColor = _xyDynSearchSelectionFieldSegmentControlBackgroundColor;
@synthesize xyDynSearchSelectionFieldSegmentControlTintColor = _xyDynSearchSelectionFieldSegmentControlTintColor;
@synthesize xyDynFieldSearchBarTintColor = _xyDynFieldSearchBarTintColor;
@synthesize favoriteCustomerViewBadgeFillColor = _favoriteCustomerViewBadgeFillColor;
@synthesize favoriteCustomerViewBadgeStrokeColor = _favoriteCustomerViewBadgeStrokeColor;
@synthesize favoriteCustomerViewBadgeStrokeWidth = _favoriteCustomerViewBadgeStrokeWidth;
@synthesize favoriteCustomerViewBadgeTextColor = _favoriteCustomerViewBadgeTextColor;
@synthesize favoriteCustomerViewBadgeShadow = _favoriteCustomerViewBadgeShadow;
@synthesize style = _style;

+(XYSkinManager*)instance{
    if (_instance == nil) {
        _instance = [XYSkinManager new];
        _instance.navigationBarBarStyle = UIBarStyleBlack;
//        _instance.navigationBarTitleColor = [UIColor SAPGoldenButtonColor];
        _instance.navigationBarTitleFont = [UIFont boldSystemFontOfSize:18];
//        _instance.xyButtonTableCellTextColor = [UIColor SAPGoldenButtonColor];
//        _instance.xyButtonTableCellBackgroundColor = [UIColor SAPGreyButtonColor];
        _instance.xyClearButtonTableCellTextColor = [UIColor blackColor];
        _instance.xyClearButtonTableCellBackgroundColor = [UIColor clearColor];
        _instance.xyDynFieldSearchBarStyle = UIBarStyleBlack;
        _instance.xyDynFieldSearchBarBackgroundColor = [UIColor blackColor];
        _instance.xyPickerFieldBarStyle = (UIBarStyle)UIBarStyleBlack;
        _instance.xyTableCellLabelColor = [UIColor blackColor];
        _instance.xyTableCellTextColor = [UIColor blackColor];
        
        _instance.favoriteCustomerViewBadgeFillColor = [UIColor redColor];
        _instance.favoriteCustomerViewBadgeStrokeWidth = 2.0;
        _instance.favoriteCustomerViewBadgeTextColor = [UIColor whiteColor];
        _instance.favoriteCustomerViewBadgeStrokeColor = [UIColor whiteColor];
        _instance.favoriteCustomerViewBadgeShadow = YES;
        
    }
    return _instance;
}

-(void)setStyle:(XYSkinStyle)style{
    _style = style;
    switch (_style) {
        
        case XYSkinStyleDefault:{
            
            if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
                // Default Style above 7.0
                _navigationBarBarStyle = UIBarStyleBlack;
                _navigationBarBarTintColor = [UIColor clearColor];
                _navigationBarBottomLineColor = nil;
//                _navigationBarTitleColor = [UIColor SAPGoldenButtonColor];
                _navigationBarTintColor = nil;
//                _xyButtonTableCellTextColor = [UIColor SAPGoldenButtonColor];
//                _xyButtonTableCellBackgroundColor = [UIColor SAPGreyButtonColor];
                _xyClearButtonTableCellTextColor = [UIColor blackColor];
                _xyClearButtonTableCellBackgroundColor = [UIColor whiteColor];
                _xyDynFieldSearchBarStyle = UIBarStyleBlack;
                _xyPickerFieldBarStyle = (UIBarStyle)UIBarStyleBlack;
                _xyBubbleViewMessageInputBarBackground = [UIImage imageNamed:@"MessageInputBarBackground"];
                _xyBubbleViewMessageInputFieldBackground = [UIImage imageNamed:@"MessageInputFieldBackground"];
                _xyBubbleViewMessageSendButtonBackground = [UIImage imageNamed:@"SendButton"];
                _xyBubbleViewMessageSendButtonHighlighted = [UIImage imageNamed:@"SendButtonHighlighted"];
                _xyBubbleViewCellStyle = XYBubbleCellStyleDefault;
                _xyBubbleViewCellStyle = XYBubbleCellStyleDefault;
                _xyAlertViewStyle = XYAlertViewStyleDefault;
                _xyBubbleViewBackgroundColor = [XYUtility iOS6messageAppBackgroundColor];
                _xyTableCellLabelColor = [UIColor blackColor];
                _xyTableCellTextColor = [UIColor blackColor];
                _xyDynSearchSelectionFieldSegmentControlBackgroundColor = [UIColor clearColor];
                _xyDynSearchSelectionFieldSegmentControlTintColor = [UIColor grayColor];
                _favoriteCustomerViewBadgeFillColor = [UIColor redColor];
                _favoriteCustomerViewBadgeStrokeWidth = 2.0;
                _favoriteCustomerViewBadgeTextColor = [UIColor whiteColor];
                _favoriteCustomerViewBadgeStrokeColor = [UIColor whiteColor];
                _favoriteCustomerViewBadgeShadow = YES;
            } else {
                // Default style below 7.0
                _navigationBarBarStyle = UIBarStyleBlack;
//                _navigationBarBarTintColor = [UIColor SAPGoldenButtonColor];
//                _navigationBarTitleColor = [UIColor SAPGoldenButtonColor];
//                _navigationBarTintColor = [UIColor SAPGoldenButtonColor];
                _navigationBarBottomLineColor = nil;
//                _xyButtonTableCellTextColor = [UIColor SAPGoldenButtonColor];
//                _xyButtonTableCellBackgroundColor = [UIColor SAPGreyButtonColor];
                _xyClearButtonTableCellTextColor = [UIColor blackColor];
                _xyClearButtonTableCellBackgroundColor = [UIColor whiteColor];
                _xyDynFieldSearchBarStyle = UIBarStyleBlack;
                _xyPickerFieldBarStyle = (UIBarStyle)UIBarStyleBlack;
                _xyBubbleViewMessageInputBarBackground = [UIImage imageNamed:@"MessageInputBarBackground"];
                _xyBubbleViewMessageInputFieldBackground = [UIImage imageNamed:@"MessageInputFieldBackground"];
                _xyBubbleViewMessageSendButtonBackground = [UIImage imageNamed:@"SendButton"];
                _xyBubbleViewMessageSendButtonHighlighted = [UIImage imageNamed:@"SendButtonHighlighted"];
                _xyBubbleViewCellStyle = XYBubbleCellStyleDefault;
                _xyAlertViewStyle = XYAlertViewStyleDefault;
                _xyBubbleViewBackgroundColor = [XYUtility iOS6messageAppBackgroundColor];
                _xyTableCellLabelColor = [UIColor blackColor];
                _xyTableCellTextColor = [UIColor blackColor];
                _xyDynSearchSelectionFieldSegmentControlBackgroundColor = [UIColor clearColor];
                _xyDynSearchSelectionFieldSegmentControlTintColor = [UIColor grayColor];
                _favoriteCustomerViewBadgeFillColor = [UIColor redColor];
                _favoriteCustomerViewBadgeStrokeWidth = 2.0;
                _favoriteCustomerViewBadgeTextColor = [UIColor whiteColor];
                _favoriteCustomerViewBadgeStrokeColor = [UIColor whiteColor];
                _favoriteCustomerViewBadgeShadow = YES;
            }
        }
            break;
        case XYSkinStyleUI5:{
            // UI Style
            if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
                // UI5 Style above 7.0
                _navigationBarBarStyle = UIBarStyleDefault;
                _navigationBarBarTintColor = [UIColor whiteColor];
                _navigationBarTitleColor = [UIColor grayColor];
                _navigationBarTintColor = [XYUtility sapBlueColor];
                _navigationBarBottomLineColor = [XYUtility sapBlueColor];
                _xyButtonTableCellTextColor = [XYUtility sapBlueColor];
                _xyButtonTableCellBackgroundColor = [UIColor clearColor];
                _xyClearButtonTableCellTextColor = [XYUtility sapBlueColor];
                _xyClearButtonTableCellBackgroundColor = [UIColor clearColor];
                _xyDynFieldSearchBarStyle = UIBarStyleDefault;
                _xyPickerFieldBarStyle = UIBarStyleDefault;
                _xyBubbleViewMessageSendButtonColor = [XYUtility sapBlueColor];
                _xyBubbleViewCellStyle = XYBubbleCellStyleUI5;
                _xyAlertViewStyle = XYAlertViewStyleUI5Light;
                _xyBubbleViewBackgroundView = [XYUtility sapUI5BackgroundViewWithFrame:[UIScreen mainScreen].bounds];
                _xyTableCellLabelColor = [UIColor blackColor];
                _xyTableCellTextColor = [UIColor grayColor];
                _xyDynSearchSelectionFieldSegmentControlBackgroundColor = [UIColor whiteColor];
                _xyDynSearchSelectionFieldSegmentControlTintColor = [XYUtility sapBlueColor];
                
                _xyDynFieldSearchBarTintColor = [XYUtility sapBlueColor];
                _favoriteCustomerViewBadgeFillColor = [UIColor redColor];
                _favoriteCustomerViewBadgeStrokeWidth = 0;
                _favoriteCustomerViewBadgeTextColor = [UIColor whiteColor];
                _favoriteCustomerViewBadgeStrokeColor = [UIColor clearColor];
                _favoriteCustomerViewBadgeShadow = NO;
            } else {
                // UI5 style below 7.0
                _navigationBarBarStyle = UIBarStyleBlack;
//                _navigationBarBarTintColor = [UIColor SAPGoldenButtonColor];
//                _navigationBarTitleColor = [UIColor SAPGoldenButtonColor];
//                _navigationBarTintColor = [UIColor SAPGoldenButtonColor];
//                _xyButtonTableCellTextColor = [UIColor SAPGoldenButtonColor];
//                _xyButtonTableCellBackgroundColor = [UIColor SAPGreyButtonColor];
                _xyClearButtonTableCellTextColor = [UIColor blackColor];
                _xyClearButtonTableCellBackgroundColor = [UIColor whiteColor];
                _xyDynFieldSearchBarStyle = UIBarStyleBlack;
                _xyPickerFieldBarStyle = UIBarStyleBlack;
                
                _xyBubbleViewMessageInputBarBackground = [UIImage imageNamed:@"MessageInputBarBackground"];
                _xyBubbleViewMessageInputFieldBackground = [UIImage imageNamed:@"MessageInputFieldBackground"];
                _xyBubbleViewMessageSendButtonBackground = [UIImage imageNamed:@"SendButton"];
                _xyBubbleViewMessageSendButtonHighlighted = [UIImage imageNamed:@"SendButtonHighlighted"];
                _xyBubbleViewCellStyle = XYBubbleCellStyleDefault;
                _xyAlertViewStyle = XYAlertViewStyleDefault;
                _xyBubbleViewBackgroundColor = [XYUtility iOS6messageAppBackgroundColor];
                _xyTableCellLabelColor = [UIColor blackColor];
                _xyTableCellTextColor = [UIColor blackColor];
                _xyDynSearchSelectionFieldSegmentControlBackgroundColor = [UIColor clearColor];
                _xyDynSearchSelectionFieldSegmentControlTintColor = [UIColor grayColor];
                _favoriteCustomerViewBadgeFillColor = [UIColor redColor];
                _favoriteCustomerViewBadgeStrokeWidth = 2.0;
                _favoriteCustomerViewBadgeTextColor = [UIColor whiteColor];
                _favoriteCustomerViewBadgeStrokeColor = [UIColor whiteColor];
                _favoriteCustomerViewBadgeShadow = YES;
            }
        }
        default:
            break;
    }
}
@end
