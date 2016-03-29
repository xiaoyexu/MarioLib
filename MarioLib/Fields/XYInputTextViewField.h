//
//  XYInputTextViewField.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYField.h"
#import "XYUITextViewDelegate.h"
#import "XYUITextFieldDelegate.h"
#import "XYInputTextViewView.h"


/**
 This class represents a text view input area
 */
@interface XYInputTextViewField :XYField

/**
 Field view
 */
@property (nonatomic, readonly)XYInputTextViewView* view;

/**
 Whether view area is editable
 */
@property (nonatomic) BOOL editable;

/**
 Textview delegate
 */
@property (nonatomic,strong) XYUITextViewDelegate* textViewDelegate;

/**
 Initialization method with field name, frame, label, ratio
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r;

/**
 Return XYInputTextViewView
 */
-(XYInputTextViewView*)view;
@end
