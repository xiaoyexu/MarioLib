//
//  XYDynaSearchFieldViewController.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/12/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYDynaSearchFieldViewController.h"

@interface XYDynaSearchFieldViewController ()

@end

@implementation XYDynaSearchFieldViewController
{
    NSArray* _searchResult;
    NSTimer* _timer;
    NSString* _oldSearchText;
}
@synthesize advField = _advField;
@synthesize searchBar = _searchBar;
@synthesize searchBarPlaceholder = _searchBarPlaceholder;

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
    
    [XYUtility setTitle:@"Please Search..." inNavigationItem:self.navigationItem];
}

-(void)loadAdvFieldValue{
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backButton;
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearFields)];
    self.navigationItem.rightBarButtonItem = clearButton;
    _tableView.editing = NO;
    
    if (self.navigationController != nil) {
        okBtn.visible = NO;
    } else {
        okBtn.visible = YES;
    }
    
    CGRect f = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:f];
        //        _searchBar.showsCancelButton= YES;
        //        _searchBar.showsScopeBar = YES;
        _searchBar.delegate = self;
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _searchBar.placeholder = _searchBarPlaceholder;
        [self.view addSubview:_searchBar];
    }
    _searchBar.barStyle = [XYSkinManager instance].xyDynFieldSearchBarStyle;
    _searchBar.backgroundColor = [XYSkinManager instance].xyDynFieldSearchBarBackgroundColor;
    
    if (_tableView == nil) {
        
        f = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40);
        
        _tableView = [[UITableView alloc] initWithFrame:f style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
    }
    
    _tableDelegate = [XYBaseUITableViewDelegate new];
    _tableDelegate.controller = self;
    _tableDelegate.tableView = _tableView;
    _tableDelegate.cellStyle = UITableViewCellStyleSubtitle;
    _tableView.dataSource = _tableDelegate;
    _tableView.delegate = _tableDelegate;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor whiteColor];
    _searchBar.text = ((XYDynaSearchField*)_advField).selectedLabelValue.label;
    
    // If _searchBar value is set, start an initial search
    if (![XYUtility isBlank:_searchBar.text]) {
        [self searchBar:_searchBar textDidChange:_searchBar.text];
    } else {
        [self clearFieldsAndResetInitialTable];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (_advField == nil) {
        return;
    }
    
    if ([XYUtility isBlank:searchText]) {
        [self clearFieldsAndResetInitialTable];
        return;
    }
    
    XYDynaSearchField* dsf = (XYDynaSearchField*)_advField;
    
    BOOL isOnlineSearch = NO;
    
    // Check whether it's online search
    if ([dsf.delegate respondsToSelector:@selector(isOnlineSearchXYDynaSearchField:)]) {
        isOnlineSearch = [((id<XYDynaSearchFieldDelegate>)dsf.delegate) isOnlineSearchXYDynaSearchField:dsf];
    }
    
    if (isOnlineSearch) {
        // Only triggered the search every N sec to avoid multiply search request
        if (_timer == nil || ![_timer isValid]) {
            NSTimeInterval interval = 1.0;
            // Get time interval value
            if ([dsf.delegate respondsToSelector:@selector(onlineSearchTimeIntervalForXYDynaSearchField:)]) {
                interval = [((id<XYDynaSearchFieldDelegate>)dsf.delegate) onlineSearchTimeIntervalForXYDynaSearchField:dsf];
            }            
            _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(searchText:) userInfo:nil repeats:YES];
        }
    } else {
        _searchResult = [((id<XYDynaSearchFieldDelegate>)dsf.delegate) XYDynaSearchField:dsf getSearchResultListByText:searchText];
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
    XYDynaSearchField* dsf = (XYDynaSearchField*)_advField;
    
    UIActivityIndicatorViewStyle style = _searchBar.barStyle == UIBarStyleDefault ?
    UIActivityIndicatorViewStyleGray : UIActivityIndicatorViewStyleWhite;
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    spinner.frame = _searchBar.frame;
    [spinner startAnimating];
    [_searchBar addSubview:spinner];
    // Execute search in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _searchResult = [((id<XYDynaSearchFieldDelegate>)dsf.delegate) XYDynaSearchField:dsf getSearchResultListByText:_oldSearchText];
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
    [_tableDelegate.container removeAllSections];
    if (_searchResult == nil || _searchResult.count == 0) {
        [_tableDelegate.container addXYTableCell:[self getNoDataTableCell] Level:XYViewLevelWorkArea section:0];
    } else {
        for (id result in _searchResult) {
            if ([result isKindOfClass:[XYLabelValue class]]) {
                XYLabelValue* lv = (XYLabelValue*)result;
                XYTableCell* cell = [XYTableCellFactory cellOfLabel:lv.value label:lv.label ratio:1 value:@""];
                cell.selectable = YES;
                [_tableDelegate.container addXYTableCell:cell Level:XYViewLevelWorkArea section:0];
            } else if ([result isKindOfClass:[XYTableCell class]]) {
                [_tableDelegate.container addXYTableCell:result Level:XYViewLevelWorkArea section:0];
            }
        }
    }
    [_tableView reloadData];
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

//    MDF Store saving
//    MDFStorage* storage = [[MDFFramework instance] storage];
//    [storage setValue:[recentSearchList JSONRepresentation] forAttributeWithName:recentSearchKey inScope:MDFScopeGroup];
//    [storage synchronize];
}

-(void)loadRecentSearchText{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
    
    NSArray* recentSearchList = [userDefault arrayForKey:recentSearchKey];
    
//    MDF Store loading
//    MDFStorage* storage = [[MDFFramework instance] storage];
//    MDFAttribute* attribute = [storage attributeWithName:recentSearchKey inScope:MDFScopeGroup];
//    NSArray* recentSearchList = [attribute.value JSONValue];
    
    if (recentSearchList != nil && recentSearchList.count != 0) {
        // Add recent search item in list, plus "Clear" button
        [_tableDelegate.container removeAllSections];
        
        XYTableCell* clearHistoryBtn = [XYTableCellFactory cellOfClearButton:@"clearBtn" label:@"Clear history"];
        [_tableDelegate.container addXYTableCell:clearHistoryBtn Level:XYViewLevelWorkArea section:0];
        
        for (NSString* result in recentSearchList) {
            XYTableCell* tc = [XYTableCellFactory defaultCellOfIdentifier:result];
            tc.selectable = YES;
            tc.text = result;
            tc.type = @"RecentItem";
            [_tableDelegate.container addXYTableCell:tc Level:XYViewLevelWorkArea section:0];
        }
        [_tableView reloadData];
    }
}

-(void)onSelectXYTableCell:(XYTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell.name isEqualToString:@"clearBtn"]) {
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
        
        [userDefault removeObjectForKey:recentSearchKey];
        [userDefault synchronize];
        [_tableDelegate.container removeAllSections];
        [_tableView reloadData];
        return;
    }
    
    if ([cell.type isEqual:@"RecentItem"]) {
        _searchBar.text = cell.text;
        [self searchBar:_searchBar textDidChange:_searchBar.text];
        return;
    }
    
    id selectedResult = [_searchResult objectAtIndex:indexPath.row];
    if ([selectedResult isKindOfClass:[XYLabelValue class]]) {
        ((XYDynaSearchField*)_advField).selectedLabelValue = selectedResult;
    } else if ([selectedResult isKindOfClass:[XYTableCell class]]){
        XYLabelValue* lv = [XYLabelValue labelWith:cell.text value:cell.name];
        lv.object = cell.object;
        ((XYDynaSearchField*)_advField).selectedLabelValue = lv;
    }
    
    XYDynaSearchField* dsf = (XYDynaSearchField*)_advField;
    if ([dsf.delegate respondsToSelector:@selector(XYDynaSearchField:didSelectXYTableCell:)]) {
        [dsf.delegate XYDynaSearchField:dsf didSelectXYTableCell:cell];
    } else {
        [self backAction];
    }
}

-(void)customizedScrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

-(void)backAction{
    XYDynaSearchField* dsf = (XYDynaSearchField*)self.advField;
    if ([_searchBar.text isEqualToString:@""]) {
        dsf.selectedLabelValue = [XYLabelValue new];
    }
    
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
    if (((XYDynaSearchField*)_advField).enableSearchTextHistory) {
        [self loadRecentSearchText];
    } else {
        [_tableDelegate.container removeAllSections];
        [_tableView reloadData];
    }
}

-(void)clearFields{
    [self clearFieldsAndResetInitialTable];
}
@end
