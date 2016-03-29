//
//  XYSelectionListViewController.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseUITableViewController.h"
#import "XYSelectionField.h"
#import "XYBaseUITableViewDelegate.h"
#import "XYButtonTableCell.h"
#import "XYTableCellFactory.h"

@class XYSelectionField;
@interface XYSelectionListViewController : XYBaseUITableViewController <XYAdvFieldViewControllerDelegate>
{
    XYButtonTableCell* okBtn;
}

@end