//
//  XYDynaSearchSelectionFieldViewController.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 6/4/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYBaseUIViewController.h"
#import "XYBaseUITableViewDelegate.h"
#import "XYDynaSearchSelectionField.h"
#import "XYDynaSearchFieldDelegate.h"
#import "XYSkinManager.h"

@interface XYDynaSearchSelectionFieldViewController : XYBaseUIViewController<UISearchBarDelegate, XYAdvFieldViewControllerDelegate>
{
    UISearchBar* _searchBar;
    UITableView* _tableView;
    XYBaseUITableViewDelegate* _tableDelegate;
}

@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) UISegmentedControl* segment;
@property (nonatomic, strong) NSString* searchBarPlaceholder;
@end
