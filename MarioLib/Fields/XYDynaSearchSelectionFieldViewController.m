//
//  XYDynaSearchSelectionFieldViewController.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 6/4/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYDynaSearchSelectionFieldViewController.h"

@interface XYDynaSearchSelectionFieldViewController ()

@end

@implementation XYDynaSearchSelectionFieldViewController
{
    NSArray* _searchResult;
    NSTimer* _timer;
    NSString* _oldSearchText;
    UISwipeGestureRecognizer* _swipeGRRight;
    UISwipeGestureRecognizer* _swipeGRLeft;
    
    NSArray* _allSelectionList;
    NSArray* _recentSelectionList;
}
@synthesize advField = _advField;
@synthesize searchBar = _searchBar;
@synthesize segment = _segment;
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
	// Do any additional setup after loading the view.
    [XYUtility setTitle:@"Please Select..." inNavigationItem:self.navigationItem];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)loadAdvFieldValue{
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backButton;
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearFields)];
    self.navigationItem.rightBarButtonItem = clearButton;
    _tableView.editing = NO;
    
    CGRect f = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:f];
        _searchBar.delegate = self;
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _searchBar.placeholder = _searchBarPlaceholder;
        [self.view addSubview:_searchBar];
    }
    _searchBar.barStyle = [XYSkinManager instance].xyDynFieldSearchBarStyle;
    _searchBar.backgroundColor = [XYSkinManager instance].xyDynFieldSearchBarBackgroundColor;
    
    if (_segment == nil) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"Recent selection",@"All selection"]];
        _segment.frame = CGRectMake(2, 42, self.view.bounds.size.width - 4, 20);
        _segment.backgroundColor = [XYSkinManager instance].xyDynSearchSelectionFieldSegmentControlBackgroundColor;
        _segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segment.tintColor = [XYSkinManager instance].xyDynSearchSelectionFieldSegmentControlTintColor;
        _segment.segmentedControlStyle = UISegmentedControlStyleBar;
        [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segment];
    }
    
    if (_tableView == nil) {
        
        f = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
        
        _tableView = [[UITableView alloc] initWithFrame:f style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
    }
    
    if (_swipeGRRight == nil) {
        _swipeGRRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnTableView:)];
        _swipeGRRight.direction = UISwipeGestureRecognizerDirectionRight;
        [_tableView addGestureRecognizer:_swipeGRRight];
    }
    
    if (_swipeGRLeft == nil) {
        _swipeGRLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnTableView:)];
        _swipeGRLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [_tableView addGestureRecognizer:_swipeGRLeft];
    }
    
    _tableDelegate = [XYBaseUITableViewDelegate new];
    _tableDelegate.controller = self;
    _tableDelegate.tableView = _tableView;
    _tableDelegate.cellStyle = UITableViewCellStyleSubtitle;
    _tableView.dataSource = _tableDelegate;
    _tableView.delegate = _tableDelegate;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    // Check recent items
    _recentSelectionList = [self getSelectedValueList];
    _allSelectionList = ((XYDynaSearchSelectionField*)_advField).selection;
    
    if (_recentSelectionList == nil || _recentSelectionList.count == 0) {
        _segment.selectedSegmentIndex = 1;
    } else {
        _segment.selectedSegmentIndex = 0;
    }
    [self segmentValueChanged:_segment];
}

-(void)segmentValueChanged:(id)sender{
    UISegmentedControl* seg = (UISegmentedControl*)sender;
    if (seg.selectedSegmentIndex == 0) {
        [self loadRecentSelection];
        NSRange range = NSMakeRange(0, _tableView.numberOfSections);
        [_tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationRight];
    } else {
        [self loadAllSelection];
        NSRange range = NSMakeRange(0, _tableView.numberOfSections);
        [_tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(void)loadRecentSelection{
    [_tableDelegate.container removeAllSections];
    if (_recentSelectionList != nil && _recentSelectionList.count != 0) {
        XYTableCell* clearHistoryBtn = [XYTableCellFactory cellOfClearButton:@"clearBtn" label:@"Clear history"];
        [_tableDelegate.container addXYTableCell:clearHistoryBtn Level:XYViewLevelWorkArea section:0];
        for (XYLabelValue* lv in _recentSelectionList) {
            XYTableCell* cell = [XYTableCellFactory defaultCellOfIdentifier:@"item"];
            cell.text = lv.label;
            if ([lv isEqual:((XYDynaSearchSelectionField*)_advField).selectedLabelValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            [_tableDelegate.container addXYTableCell:cell Level:XYViewLevelWorkArea section:0];
        }

    }
    [_tableView reloadData];
}

-(void)loadAllSelection{
    [_tableDelegate.container removeAllSections];
    for (XYLabelValue* lv in _allSelectionList) {
        XYTableCell* cell = [XYTableCellFactory defaultCellOfIdentifier:@"item"];
        cell.text = lv.label;
        if ([lv isEqual:((XYDynaSearchSelectionField*)_advField).selectedLabelValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [_tableDelegate.container addXYTableCell:cell Level:XYViewLevelWorkArea section:0];
    }
    [_tableView reloadData];
}


-(void)swipeOnTableView:(id)sender{
    UISwipeGestureRecognizer* sw = (UISwipeGestureRecognizer*)sender;
    if (sw.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_segment.selectedSegmentIndex == 1) {
            _segment.selectedSegmentIndex = 0;
            [self segmentValueChanged:_segment];
        }
    } else {
        if (_segment.selectedSegmentIndex == 0) {
            _segment.selectedSegmentIndex = 1;
            [self segmentValueChanged:_segment];
        }
    }
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([XYUtility isBlank:searchText]) {
        [self clearFieldsAndResetInitialTable];
        return;
    }
        
    NSMutableArray* result = [NSMutableArray new];
    for (XYLabelValue* lv in ((XYDynaSearchSelectionField*)_advField).selection) {
        NSRange r = [[lv.label uppercaseString] rangeOfString:[searchText uppercaseString]];
        NSRange r2 = [[lv.value uppercaseString] rangeOfString:[searchText uppercaseString]];
        if ((r.location != NSNotFound && r.length > 0) || (r2.location != NSNotFound && r2.length > 0)) {
            [result addObject:lv];
        }
    }
    _allSelectionList = result;
    
    result = [NSMutableArray new];
    for (XYLabelValue* lv in [self getSelectedValueList]) {
        NSRange r = [[lv.label uppercaseString] rangeOfString:[searchText uppercaseString]];
        NSRange r2 = [[lv.value uppercaseString] rangeOfString:[searchText uppercaseString]];
        if ((r.location != NSNotFound && r.length > 0) || (r2.location != NSNotFound && r2.length > 0)) {
            [result addObject:lv];
        }
    }
    _recentSelectionList = result;
    if (_segment.selectedSegmentIndex == 0) {
        [self loadRecentSelection];
    } else {
        [self loadAllSelection];
    }
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


-(NSArray*)getSelectedValueList{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
    NSArray* recentSearchList = [userDefault arrayForKey:recentSearchKey];
    NSMutableArray* result = [NSMutableArray new];
    for (NSDictionary* dic in recentSearchList) {
        [result addObject:[XYLabelValue labelWith:[dic objectForKey:@"label"] value:[dic objectForKey:@"value"]]];
    }
    
    return result;
}

-(void)saveSelectedValue:(XYLabelValue*)labelValue{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
    
    NSMutableArray* recentSelectionList = [NSMutableArray arrayWithArray:[userDefault arrayForKey:recentSearchKey]];
    
    if (recentSelectionList == nil) {
        recentSelectionList = [NSMutableArray new];
    }
    
    NSDictionary* dic = @{@"label":labelValue.label, @"value":labelValue.value};
    
    if ([recentSelectionList containsObject:dic]) {
        [recentSelectionList removeObject:dic];
    }
    [recentSelectionList insertObject:dic atIndex:0];
    [userDefault setObject:recentSelectionList forKey:recentSearchKey];
    [userDefault synchronize];
}

-(void)onSelectXYTableCell:(XYTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell.name isEqualToString:@"clearBtn"]) {
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        NSString* recentSearchKey = [NSString stringWithFormat:@"%@RecentItems",_advField.name];
        
        [userDefault removeObjectForKey:recentSearchKey];
        [userDefault synchronize];
        _recentSelectionList = [self getSelectedValueList];
        [self loadRecentSelection];
        return;
    }
    
    id selectedResult;
    if (_segment.selectedSegmentIndex == 0) {
        selectedResult = [_recentSelectionList objectAtIndex:indexPath.row - 1];
    } else {
        selectedResult = [_allSelectionList objectAtIndex:indexPath.row];
    }

    if ([selectedResult isKindOfClass:[XYLabelValue class]]) {
        if ([((XYDynaSearchSelectionField*)_advField).selectedLabelValue isEqual:selectedResult]) {
            // De-select
            ((XYDynaSearchSelectionField*)_advField).selectedLabelValue =  [XYLabelValue new];
            if (_segment.selectedSegmentIndex == 0) {
                [self loadRecentSelection];
            } else {
                [self loadAllSelection];
            }
        } else {
            // Select
            ((XYDynaSearchSelectionField*)_advField).selectedLabelValue = selectedResult;
            [self saveSelectedValue:((XYDynaSearchSelectionField*)_advField).selectedLabelValue];
        }
        
    } else if ([selectedResult isKindOfClass:[XYTableCell class]]){
        XYLabelValue* lv = [XYLabelValue labelWith:cell.text value:cell.name];
        ((XYDynaSearchSelectionField*)_advField).selectedLabelValue = lv;
    }
    [self backAction];
}

-(void)customizedScrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

-(void)backAction{
    XYDynaSearchSelectionField* dsf = (XYDynaSearchSelectionField*)self.advField;
    
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
    _allSelectionList = ((XYDynaSearchSelectionField*)_advField).selection;
    _recentSelectionList = [self getSelectedValueList];
    ((XYDynaSearchSelectionField*)_advField).selectedLabelValue =  [XYLabelValue new];
    if (_segment.selectedSegmentIndex == 0) {
        [self loadRecentSelection];
    } else {
        [self loadAllSelection];
    }
}

-(void)clearFields{
    [self clearFieldsAndResetInitialTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
