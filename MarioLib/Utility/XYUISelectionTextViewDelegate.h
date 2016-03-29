//
//  XYUISelectionTextViewDelegate.h
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYField.h"

/**
 An implementation class for UITextViewDelegate
 */
@interface XYUISelectionTextViewDelegate : NSObject <UITextViewDelegate>

/**
 Reference to XYField object
 */
@property (nonatomic, strong) XYField* field;
@end
