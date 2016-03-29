//
//  XYUIAlertView2.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 12/19/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYActivityIndicatorIconView.h"
#import "XYProgressIndicatorView.h"
#import "XYStatusUpdateDelegate.h"
#import "XYUtility.h"

typedef enum {
    XYUIAlertViewActivityIndicator,
    XYUIAlertViewProgressIndicator,
    XYUIAlertViewNone
} XYUIAlertViewStyle;

@interface XYUIAlertView2 : UIView <XYStatusUpdateDelegate>

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property(nonatomic,assign) id delegate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *message;

@property(nonatomic,assign) XYUIAlertViewStyle alertViewStyle;
@property(nonatomic,readonly) NSInteger numberOfButtons;
//@property(nonatomic) NSInteger cancelButtonIndex;      // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1
//
//@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used
@property(nonatomic,readonly,getter=isVisible) BOOL visible;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
//- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex NS_AVAILABLE_IOS(5_0);
- (NSInteger)addButtonWithTitle:(NSString *)title;    // returns index of button. 0 based.
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
@end

@protocol XYUIAlertViewDelegate <NSObject>
- (void)alertView:(XYUIAlertView2 *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
