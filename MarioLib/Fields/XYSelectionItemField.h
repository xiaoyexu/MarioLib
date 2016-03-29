//
//  XYSelectionItemField.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYField.h"
#import "XYInputTextViewView.h"

/**
 XYSelectionItemField represents an item in XYSelectionField
 */
@interface XYSelectionItemField : XYField

/**
 Initialization method with field name, frame, label, ratio
 @param name Name or identifier of field
 @param f Frame of XYBaseView
 @param label Label string to display for this field
 @param r Ratio of left view and right view
 */
-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r;
@end
