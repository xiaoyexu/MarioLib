//
//  XYAdvField.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYAdvField.h"
#import "XYSelectorObject.h"
#import "XYFieldSelectOption.h"
#import "XYUITextViewDelegate.h"
#import "XYUISelectionTextViewDelegate.h"
#import "XYSelectOptionViewController.h"
#import "XYInputTextViewView.h"

@class XYUISelectionTextViewDelegate;

/**
 This class represents a select option field, user can choose sign, option and enter low value high value
 */
@interface XYSelectOptionField : XYAdvField
{
    @protected
    XYFieldSelectOption* _fieldSelectionOption;
}
@property (nonatomic,readonly) XYInputTextViewView* view;
@property (nonatomic,strong) XYUITextViewDelegate* textViewDelegate;
@property (nonatomic,strong) XYUISelectionTextViewDelegate* popOverTextViewDelegate;
@property (nonatomic) NSInteger minHeight;
@property (nonatomic) NSInteger maxHeight;
@property (nonatomic, readonly) XYSelectorObject*  selectionCompletedSelector;
@property (nonatomic,strong) XYFieldSelectOption* fieldSelectionOption;

/**
 Advanced field type, text or date picker
 */
@property (nonatomic) XYAdvFieldType advFieldType;

/**
 Placeholder for low value input box
 */
@property (nonatomic) NSString* lowValuePlaceholder;

/**
 Keyboard type for low value input box
 */
@property (nonatomic) UIKeyboardType lowValueKeyboardType;

/**
 Placeholder for high value input box
 */
@property (nonatomic) NSString* highValuePlaceholder;

/**
 Keyboard type for high value input box
 */
@property (nonatomic) UIKeyboardType highValueKeyboardType;

/**
 UIDatePickerMode if type is XYAdvFieldTypeDate
 */
@property (nonatomic) UIDatePickerMode datePickMode;

/**
 NSDictionary of possible sign
 */
@property (nonatomic,strong) NSDictionary* signDictionary;

/**
 NSDictionary of possible operator(option)
 */
@property (nonatomic,strong) NSDictionary* operatorDictionary;

/**
 Result date value format, for both lowValue and highValue
 */
@property (nonatomic,strong) NSString* dateValueFormat;

/**
 Date from for type XYAdvFieldTypeDate
 */
@property (nonatomic,strong) NSDate* dateFrom;

/**
 Date to for type XYAdvFieldTypeDate
 */
@property (nonatomic,strong) NSDate* dateTo;

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
 @param value The selected item value, not label. E.g. EQ|12345 or BT|1|10
 */

-(void)setValue:(NSString *)value;
/**
 @return Selected item value, not label
 */
-(NSString*)value;

@end
