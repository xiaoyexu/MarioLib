//
//  XYDynaSearchFieldViewController.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseUIViewController.h"
#import "XYBaseUITableViewDelegate.h"
#import "XYDynaSearchField.h"
#import "XYDynaSearchFieldDelegate.h"
#import "XYSkinManager.h"
//#import <SAPTitleLabel.h>
//#import <MDF/MDF.h>

@class XYDynaSearchField;

@interface XYDynaSearchFieldViewController : XYBaseUIViewController <UISearchBarDelegate, XYAdvFieldViewControllerDelegate>
{
    UISearchBar* _searchBar;
    UITableView* _tableView;
    XYBaseUITableViewDelegate* _tableDelegate;
    XYButtonTableCell* okBtn;
}
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (nonatomic, strong) NSString* searchBarPlaceholder;

@end
