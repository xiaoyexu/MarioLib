//
//  XYAdvField.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYField.h"
#import "XYSelectorObject.h"
#import "XYUITextViewDelegate.h"
#import "XYUISelectionTextViewDelegate.h"
#import "XYInputTextViewView.h"
#import "XYInputTextFieldView.h"
#import "XYAdvFieldDelegate.h"
#import "XYAdvFieldViewControllerDelegate.h"
#import "XYBaseUITableViewController.h"
#import "XYBaseUIViewController.h"
#import "XYKeyboardListener.h"

@class XYUISelectionTextViewDelegate;

/**
 This class represents a field need more UI interaction with user.
 E.g. Selection, dynamic search
 Such field can be used in XYBaseUITableViewController, or on the ipad, using popover view controller
 */
@interface XYAdvField : XYField <XYAdvFieldDelegate>
{
    @protected
    XYSelectorObject*  _selectionCompletedSelector;
    BOOL _isPopOverOptionView;
}

/**
 XYInputTextViewView as view
 */
@property (nonatomic,readonly) XYInputTextViewView* view;

/**
 XYUITextViewDelegate as text view delegate
 */
@property (nonatomic,strong) XYUITextViewDelegate* textViewDelegate;

/**
 XYUISelectionTextViewDelegate as text view delegate
 */
@property (nonatomic,strong) XYUISelectionTextViewDelegate* popOverTextViewDelegate;

/**
 Minimum height
 */
@property (nonatomic) NSInteger minHeight;

/**
 Maximum height
 */
@property (nonatomic) NSInteger maxHeight;

/**
 Callback selector when item selected
 */
@property (nonatomic, readonly) XYSelectorObject*  selectionCompletedSelector;

/**
 If bar button item available, use bar button item to trigger
 */
@property (nonatomic, strong) UIBarButtonItem* barButtonItem;

/**
 Initialization method with field name, frame, label, ratio
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r;

/**
 Set value
 @param value The selected item value
 */
-(void)setValue:(NSString *)value;

@end
