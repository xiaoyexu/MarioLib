//
//  XYAdvSearchViewController.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 6/17/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYBaseUIViewController.h"
#import "XYBaseUITableViewDelegate.h"
#import "XYAdvSearchField.h"

@interface XYAdvSearchFieldViewController : XYBaseUIViewController<UISearchBarDelegate,XYAdvFieldViewControllerDelegate>
@property (nonatomic, strong) NSString* searchBarPlaceholder;
@property (nonatomic, strong) NSString* navigationBarTitle;
@end
