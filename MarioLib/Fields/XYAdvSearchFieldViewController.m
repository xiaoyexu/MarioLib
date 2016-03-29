//
//  XYAdvSearchViewController.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 6/17/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYAdvSearchFieldViewController.h"

@interface XYAdvSearchFieldViewController ()

@end

@implementation XYAdvSearchFieldViewController
{
    UISearchBar* _searchBar;
    UITableView* _quickSearchTableView;
    UITableView* _normalSearchTableView;
    XYBaseUITableViewDelegate* _quickSearchTableViewDelegate;
    XYBaseUITableViewDelegate* _normalSearchTableViewDelegate;
    NSMutableDictionary* _fieldsDic;
    XYBaseUITableViewController* _tableViewController;
    BOOL _selfAsResultViewController;
    NSArray* _searchResult;
    NSTimer* _timer;
    NSString* _oldSearchText;
    
    XYButtonTableCell* clearBtnTableCell;
    XYButtonTableCell* searchBtnTableCell;
    XYButtonTableCell* backBtnTableCell;
}
@synthesize searchBarPlaceholder = _searchBarPlaceholder;
@synthesize navigationBarTitle = _navigationBarTitle;
@synthesize advField = _advField;

-(id)init{
    if (self = [super init]) {

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    XYAdvSearchField* dsf = (XYAdvSearchField*)self.advField;
    
    // Naviation bar title
    if (![XYUtility isBlank:_navigationBarTitle]) {
        self.navigationItem.title = _navigationBarTitle;
    }
    [XYUtility setTitle:self.navigationItem.title inNavigationItem:self.navigationItem];
    
    // Quick search bar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.delegate = self;
    _searchBar.placeholder = dsf.placeholder;
    _searchBar.barStyle = [XYSkinManager instance].xyDynFieldSearchBarStyle;
    _searchBar.tintColor = [XYSkinManager instance].xyDynFieldSearchBarTintColor;
    _searchBar.backgroundColor = [XYSkinManager instance].xyDynFieldSearchBarBackgroundColor;
    
    [self.view addSubview:_searchBar];
    
    // Quick search table
    _quickSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    _quickSearchTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _quickSearchTableView.backgroundView = nil;
    _quickSearchTableView.backgroundColor = [UIColor whiteColor];
    _quickSearchTableViewDelegate = [XYBaseUITableViewDelegate new];
    _quickSearchTableViewDelegate.cellStyle = UITableViewCellStyleSubtitle;
    _quickSearchTableView.dataSource = _quickSearchTableViewDelegate;
    _quickSearchTableView.delegate = _quickSearchTableViewDelegate;
    _quickSearchTableViewDelegate.tableView = _quickSearchTableView;
    _quickSearchTableViewDelegate.controller = self;
    [self.view addSubview:_quickSearchTableView];
    _quickSearchTableView.hidden = YES;
    
    // Normal search table
    _normalSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    _normalSearchTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _normalSearchTableView.backgroundView = nil;
    _normalSearchTableView.backgroundColor = [UIColor whiteColor];
    _normalSearchTableViewDelegate = [XYBaseUITableViewDelegate new];
    _normalSearchTableView.dataSource = _normalSearchTableViewDelegate;
    _normalSearchTableView.delegate = _normalSearchTableViewDelegate;
    _normalSearchTableViewDelegate.tableView = _normalSearchTableView;
    _normalSearchTableViewDelegate.controller = self;
    [self.view addSubview:_normalSearchTableView];
    
    // Navigation bar button
    //UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(onClearNaviItemPressed)];
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onClearNaviItemPressed)];
    
    
    UIBarButtonItem* searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearchNaviItemPressed)];
    self.navigationItem.rightBarButtonItems = @[searchButton,clearButton];
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0 && _quickSearchTableView.style == UITableViewStyleGrouped) {
        _quickSearchTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0 && _normalSearchTableView.style == UITableViewStyleGrouped) {
        _normalSearchTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
    
    if (dsf.delegate != nil) {
        NSArray* fields = [dsf.delegate xyNormalFieldsForAdvSearchField:dsf];
        _fieldsDic = [NSMutableDictionary new];
        for (XYTableCell* cell in fields) {
            [_fieldsDic setObject:cell forKey:cell.name];
        }
        [_normalSearchTableViewDelegate.container addXYTableCellArray:fields];
    }

    
    int i = 0;
    
    // Search Button
    searchBtnTableCell = //[XYButtonTableCell cellWithName:@"searchBtn" XYField:nil];
    [XYTableCellFactory cellOfClearButton:@"searchBtn" label:@"Search"];
    //searchBtnTableCell.text = @"Search";
    
    // Clear Button
    clearBtnTableCell = [XYTableCellFactory cellOfClearButton:@"clearBtn" label:@"Clear"];//[XYButtonTableCell cellWithName:@"clearBtn" XYField:nil];
    //clearBtnTableCell.text = @"Clear";
    
    // Back Button
    backBtnTableCell = [XYTableCellFactory cellOfClearButton:@"backBtn" label:@"Back"];//[XYButtonTableCell cellWithName:@"backBtn" XYField:nil];
    //backBtnTableCell.text = @"Back";
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        // For iOS 7 above, added them to same section
        [_normalSearchTableViewDelegate.container addXYTableCell:searchBtnTableCell Level:XYViewLevelFooter section:i];
        [_normalSearchTableViewDelegate.container addXYTableCell:clearBtnTableCell Level:XYViewLevelFooter section:i];
        [_normalSearchTableViewDelegate.container addXYTableCell:backBtnTableCell Level:XYViewLevelFooter section:i];
        
    } else {
        [_normalSearchTableViewDelegate.container addXYTableCell:searchBtnTableCell Level:XYViewLevelFooter section:i++];
        [_normalSearchTableViewDelegate.container addXYTableCell:clearBtnTableCell Level:XYViewLevelFooter section:i++];
        [_normalSearchTableViewDelegate.container addXYTableCell:backBtnTableCell Level:XYViewLevelFooter section:i++];
    }
    
    if (![XYUtility isBlank:_searchBar.text]) {
        [self searchBar:_searchBar textDidChange:_searchBar.text];
    } else {
        [self clearFieldsAndResetInitialTable];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.navigationController != nil) {
        searchBtnTableCell.visible = NO;
        backBtnTableCell.visible = NO;
    } else {
        searchBtnTableCell.visible = YES;
        backBtnTableCell.visible = YES;
    }
    
    [_normalSearchTableView reloadData];
}

-(void)loadRecentSearchText{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
    
    NSArray* recentSearchList = [userDefault arrayForKey:recentSearchKey];
    
    if (recentSearchList != nil && recentSearchList.count != 0) {
        // Add recent search item in list, plus "Clear" button
        [_quickSearchTableViewDelegate.container removeAllSections];
        
        XYTableCell* clearHistoryBtn = [XYTableCellFactory cellOfClearButton:@"clearHistoryBtn" label:@"Clear history"];
        [_quickSearchTableViewDelegate.container addXYTableCell:clearHistoryBtn Level:XYViewLevelWorkArea section:0];
        
        for (NSString* result in recentSearchList) {
            XYTableCell* tc = [XYTableCellFactory defaultCellOfIdentifier:result];
            tc.selectable = YES;
            tc.text = result;
            tc.type = @"RecentItem";
            [_quickSearchTableViewDelegate.container addXYTableCell:tc Level:XYViewLevelWorkArea section:0];
        }
        [_quickSearchTableView reloadData];
    }
}

-(void)loadAdvFieldValue{
  
}

-(void)onClearNaviItemPressed{
    XYAdvSearchField* dsf = (XYAdvSearchField*)self.advField;
    if ([_searchBar.text isEqualToString:@""]) {
        dsf.selectedLabelValue = [XYLabelValue new];
    }
    [self backAction];
}

-(void)onSearchNaviItemPressed{
    XYAdvSearchField* dsf = (XYAdvSearchField*)self.advField;
    if (dsf.delegate != nil) {
        self.busyProcessTitle = @"Searching...";
        [self performBusyProcess:^XYProcessResult *{
            XYProcessResult* result = [XYProcessResult success];
            NSArray* searchResult = [dsf.delegate xyAdvSearchField:dsf getSearchResultListByNormalFields:_fieldsDic controller:self];
            
            if (searchResult == nil || searchResult.count == 0) {
                result.success = NO;
                [result.params setValue:@"No record found!" forKey:@"error"];
            } else {
                [result.params setValue:searchResult forKey:@"searchResult"];
            }
            return result;
        }];
    }
}

-(void)handleCorrectResponse:(XYProcessResult *)result{
    NSArray* searchResult = [result.params objectForKey:@"searchResult"];
    if (searchResult != nil && searchResult.count != 0) {
        XYTableContainer* container = [XYTableContainer new];
        [container addXYTableCellArray:searchResult];
        _tableViewController = [[XYBaseUITableViewController alloc] initWithStyle:UITableViewStyleGrouped andTableContainer:container xyStyle:XYUITableViewStyleNone cellStyle:UITableViewCellStyleSubtitle andTitle:@"Result"];
        _tableViewController.tableDelegate.controller = self;
        _selfAsResultViewController = YES;
        if (self.navigationController != nil) {
            [self.navigationController pushViewController:_tableViewController animated:YES];
        } else {
            [self presentViewController:_tableViewController animated:YES completion:nil];
        }
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = YES;
    _selfAsResultViewController = YES;
    [self showQuickSearchTableView:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (_advField == nil) {
        return;
    }
    
    if ([XYUtility isBlank:searchText]) {
        [self clearFieldsAndResetInitialTable];
        return;
    }
    
    XYAdvSearchField* dsf = (XYAdvSearchField*)_advField;
    
    BOOL isOnlineSearch = NO;
    
    // Check whether it's online search
    if ([dsf.delegate respondsToSelector:@selector(isOnlineSearchXYAdvSearchField:)]) {
        isOnlineSearch = [dsf.delegate isOnlineSearchXYAdvSearchField:dsf];
    }
    
    if (isOnlineSearch) {
        // Only triggered the search every N sec to avoid multiply search request
        if (_timer == nil || ![_timer isValid]) {
            NSTimeInterval interval = 1.0;
            // Get time interval value
            if ([dsf.delegate respondsToSelector:@selector(onlineSearchTimeIntervalForXYAdvSearchField:)]) {
                interval = [dsf.delegate onlineSearchTimeIntervalForXYAdvSearchField:dsf];
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(searchText:) userInfo:nil repeats:YES];
        }
    } else {
        _searchResult = [dsf.delegate xyAdvSearchField:dsf getSearchResultListByText:searchText];
        if (((XYDynaSearchField*)_advField).enableSearchTextHistory) {
            // Save search text
            [self saveSearchText:searchText];
        }
        [self buildResultTableCell];
    }

}

-(void)searchText:(NSTimer*)timer{
    
    if ([_searchBar.text isEqualToString:_oldSearchText]) {
        // Disable timer if no more change in search text
        [timer invalidate];
        return;
    }
    
    if ([XYUtility isBlank:_searchBar.text]) {
        [self clearFieldsAndResetInitialTable];
        return;
    }
    
    _oldSearchText = _searchBar.text;
    XYAdvSearchField* dsf = (XYAdvSearchField*)_advField;
    
    UIActivityIndicatorViewStyle style = _searchBar.barStyle == UIBarStyleDefault ?
    UIActivityIndicatorViewStyleGray : UIActivityIndicatorViewStyleWhite;
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    spinner.frame = _searchBar.frame;
    [spinner startAnimating];
    [_searchBar addSubview:spinner];
    // Execute search in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _searchResult = [dsf.delegate xyAdvSearchField:dsf getSearchResultListByText:_oldSearchText];
        if (((XYDynaSearchField*)_advField).enableSearchTextHistory) {
            // Save search text
            [self saveSearchText:_oldSearchText];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            [self buildResultTableCell];
        });
    });
}

-(void)buildResultTableCell{
    [_quickSearchTableViewDelegate.container removeAllSections];
    if (_searchResult == nil || _searchResult.count == 0) {
        [_quickSearchTableViewDelegate.container addXYTableCell:[self getNoDataTableCell] Level:XYViewLevelWorkArea section:0];
    } else {
        for (id result in _searchResult) {
            if ([result isKindOfClass:[XYLabelValue class]]) {
                XYLabelValue* lv = (XYLabelValue*)result;
                XYTableCell* cell = [XYTableCellFactory cellOfLabel:lv.value label:lv.label ratio:1 value:@""];
                cell.selectable = YES;
                [_quickSearchTableViewDelegate.container addXYTableCell:cell Level:XYViewLevelWorkArea section:0];
            } else if ([result isKindOfClass:[XYTableCell class]]) {
                [_quickSearchTableViewDelegate.container addXYTableCell:result Level:XYViewLevelWorkArea section:0];
            }
        }
    }
    [_quickSearchTableView reloadData];
}

-(XYTableCell*)getNoDataTableCell{
    XYBaseView* v = [[XYBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    label.text = @"No data";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [v addSubview:label];
    XYTableCell* cell = [[XYTableCell alloc] initWithView:v];
    cell.name = @"_noData";
    cell.selectable = NO;
    return cell;
}

-(void)saveSearchText:(NSString*)searchText{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
    
    NSMutableArray* recentSearchList = [NSMutableArray arrayWithArray:[userDefault arrayForKey:recentSearchKey]];
    
    if (recentSearchList == nil) {
        recentSearchList = [NSMutableArray new];
    }
    
    if ([recentSearchList containsObject:searchText]) {
        [recentSearchList removeObject:searchText];
    }
    [recentSearchList insertObject:searchText atIndex:0];
    [userDefault setObject:recentSearchList forKey:recentSearchKey];
    [userDefault synchronize];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = NO;
    _selfAsResultViewController = NO;
    [self showQuickSearchTableView:NO];
    _searchBar.text = @"";
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

}

-(void)showQuickSearchTableView:(BOOL)b{
    if (b) {
        _quickSearchTableView.hidden = NO;
        _normalSearchTableView.hidden = YES;
        NSRange range = NSMakeRange(0, _quickSearchTableView.numberOfSections);
        [_quickSearchTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        _quickSearchTableView.hidden = YES;
        _normalSearchTableView.hidden = NO;
        NSRange range = NSMakeRange(0, _normalSearchTableView.numberOfSections);
        [_normalSearchTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)onSelectXYTableCell:(XYTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    [super onSelectXYTableCell:cell atIndexPath:indexPath];
    if (_selfAsResultViewController) {
        
        if ([cell.name isEqualToString:@"clearHistoryBtn"]) {
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
            
            [userDefault removeObjectForKey:recentSearchKey];
            [userDefault synchronize];
            [_quickSearchTableViewDelegate.container removeAllSections];
            [_quickSearchTableView reloadData];
            return;
        }
        
        if ([cell.type isEqual:@"RecentItem"]) {
            _searchBar.text = cell.text;
            [self searchBar:_searchBar textDidChange:_searchBar.text];
            return;
        }
        
        XYLabelValue* lv = [XYLabelValue labelWith:cell.text value:cell.name];
        lv.object = cell.object;
        ((XYAdvSearchField*)_advField).selectedLabelValue = lv;
        
        if ([((XYAdvSearchField*)_advField).delegate respondsToSelector:@selector(xyAdvSearchField:didSelectXYTableCell:)]) {
            [((XYAdvSearchField*)_advField).delegate xyAdvSearchField:(XYAdvSearchField*)_advField didSelectXYTableCell:cell];
        }
        
        UIViewController* v = nil;
        if (_tableViewController.navigationController != nil) {
            v = [_tableViewController.navigationController popViewControllerAnimated:NO];
        }
        // If v is nil, no more view avialble in navigation controller, dismiss the view or popover view
        if (v == nil) {
            if ((_popOverController != nil && _popOverController.isPopoverVisible) || self.advField.isPopOverOptionView == YES) {
                [_popOverController dismissPopoverAnimated:NO];
                return;
            } else {
                [_tableViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
        _selfAsResultViewController = NO;
        [self backAction];
    } else if ([cell.name isEqualToString:@"clearBtn"]) {
        [self clearFields];
    } else if ([cell.name isEqualToString:@"searchBtn"]) {
        [self onSearchNaviItemPressed];
    } else if ([cell.name isEqualToString:@"backBtn"]) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)backAction{
    XYAdvSearchField* dsf = (XYAdvSearchField*)self.advField;
    [dsf renderFieldView];
    if (dsf.selectionCompletedSelector != nil) {
        dsf.selectionCompletedSelector.object = dsf;
        [dsf.selectionCompletedSelector performSelector];
    }
    
    UIViewController* v = nil;
    if (self.navigationController != nil) {
        v = [self.navigationController popViewControllerAnimated:YES];
    }
    // If v is nil, no more view avialble in navigation controller, dismiss the view or popover view
    if (v == nil) {
        if ((_popOverController != nil && _popOverController.isPopoverVisible) || self.advField.isPopOverOptionView == YES) {
            [_popOverController dismissPopoverAnimated:YES];
            return;
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


-(void)clearFieldsAndResetInitialTable{
    _searchBar.text = @"";
    _oldSearchText = @"";
    if (((XYAdvSearchField*)_advField).enableSearchTextHistory) {
        [self loadRecentSearchText];
    } else {
        [_quickSearchTableViewDelegate.container removeAllSections];
        [_quickSearchTableView reloadData];
    }
}

-(void)clearFields{
    [self clearFieldsAndResetInitialTable];
    [_normalSearchTableViewDelegate clearAllFields];
}

-(void)customizedScrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
