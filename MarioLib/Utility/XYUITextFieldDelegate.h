//
//  XYUITextFieldDelegate.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYInputTextField.h"

@class XYInputTextField;

/**
 An implementation class for UITextFieldDelegate
 */
@interface XYUITextFieldDelegate : NSObject <UITextFieldDelegate>

/**
 Maximum length of text to enter
 */
@property (nonatomic) NSInteger maxLength;

/**
 Default text show when text field focused
 */
@property (nonatomic, strong) NSString* defaultValueOnEnter;

/**
 Store XYInputTextField as reference
 */
@property (nonatomic, strong) XYInputTextField* textField;

@end
