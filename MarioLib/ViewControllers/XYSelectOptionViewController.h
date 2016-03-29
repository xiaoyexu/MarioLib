//
//  XYSelectOptionViewController.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseUITableViewController.h"
#import "XYSelectionField.h"
#import "XYSelectionTableCell.h"
#import "XYInputTextFieldView.h"
#import "XYInputTextViewView.h"

@interface XYSelectOptionViewController : XYBaseUITableViewController <XYAdvFieldViewControllerDelegate>
{
    XYButtonTableCell* okBtn;
}
@property (nonatomic,strong) NSDictionary* signDictionary;
@property (nonatomic,strong) NSDictionary* operatorDictionary;
@property (nonatomic,strong) XYTableCell* lowValueCell;
@property (nonatomic,strong) XYTableCell* highValueCell;

@end
