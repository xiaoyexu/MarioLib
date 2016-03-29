//
//  XYUITextViewDelegate.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYRollableTableCell.h"
#import "XYInputTextViewView.h"

/**
 An implementation class for UITextViewDelegate
 */
@interface XYUITextViewDelegate : NSObject <UITextViewDelegate>
{
    UITableView* _tableView;
}

/**
 If set to YES, the text view is used as single line inputting
 */
@property (nonatomic) BOOL noLineBreaker;

/**
 Store reference to XYRollableTableCell object
 */
@property (nonatomic, strong) XYRollableTableCell* rollTableCell;

@end
