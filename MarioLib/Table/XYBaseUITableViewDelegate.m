//
//  XYBaseUITableViewDelegate.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseUITableViewDelegate.h"


@implementation XYBaseUITableViewDelegate
@synthesize container = _container;
@synthesize controller = _controller;
@synthesize tableView = _tableView;
@synthesize cellStyle = _cellStyle;
@synthesize loadMoreButtonEnabled = _loadMoreButtonEnabled;
@synthesize topViewEnabled = _topViewEnabled;
@synthesize bottomViewEnabled = _bottomViewEnabled;
@synthesize topView = _topView;
@synthesize bottomView = _bottomView;
@synthesize enableSwipeToDelete = _enableSwipeToDelete;

-(id)init{
    self = [super init];
    if (self) {
        _container = [XYTableContainer new];
    }
    return self;
}

-(id)initWithTableContainer:(XYTableContainer*)container{
    self = [super init];
    if (self) {
        _container = container;
    }
    return self;
}

-(void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    [self initLoadMoreButton];
}

/*
  Initialized the load more button.
 */
-(void)initLoadMoreButton{
    CGRect frame = [self tableViewContentViewFrame];
    XYActivityIndicatorView* view = [[XYActivityIndicatorView alloc] initWithFrame:frame andRatio:0.45];
    
    loadMoreBtn = [XYButtonTableCell cellWithName:@"_loadMore_" view:view];
    loadMoreBtn.backgroundColor = [UIColor whiteColor];
    ((XYActivityIndicatorView*)loadMoreBtn.view).label.textColor = [UIColor blackColor];
    ((XYActivityIndicatorView*)loadMoreBtn.view).label.text = @"More...";
    loadMoreBtn.visible = NO;
}

/*
  Return section count, also to find out index of last section
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sec = [_container countOfActualSections];
    // Find last section index
    if (_loadMoreButtonEnabled) {
        lastSection = sec - 1;
    }
    return sec;
}

/*
  Return row count of each section, also to find out last row index in last section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = [_container countOfActualRowsAtSection:section];
    // If "load more" button required, return one more row, the button always locate at last section last row
    if (_loadMoreButtonEnabled && section == lastSection) {
        lastRowInLastSection = rowCount - 1;
        return rowCount + 1;
    }
    return rowCount;
}
/*
  Check whether indexPath for load more button
 */
-(BOOL)isLoadMoreRow:(NSIndexPath*)indexPath{
    return _loadMoreButtonEnabled && indexPath.section == lastSection && indexPath.row > lastRowInLastSection ? YES : NO;
}

//-(BOOL)isLastRow:(NSIndexPath*)indexPath{
//    return indexPath.section == lastSection && indexPath.row == lastRowInLastSection ? YES : NO;
//}

/*
  Iterate each XYTableCell, creating UITableViewCell and add view onto it
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreRow:indexPath]) {
        // Display load more button
        UITableViewCell* cell = [self reusableCell:@"Cell" tableView:tableView atIndex:indexPath];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return [self renderXYTableCell:loadMoreBtn withUITableViewCell:cell ofTable:tableView atIndex:indexPath];
    }
    // Display XYTableCell
    XYTableSection* section = [[_container actualSectionArray] objectAtIndex:indexPath.section];
    XYTableCell* xyTableCell = [[section actualCellArray] objectAtIndex:indexPath.row];
    UITableViewCell* cell;
    if (xyTableCell.customizedCellForRow) {
        // For customized cell, user to draw cell on storyboard.
        // XYDummyTableCell can be used, but here only check whether cell.customizedCellForRow is YES
        cell = [self reusableCell:xyTableCell.cellIdentifier tableView:tableView atIndex:indexPath];
    } else {
        // For predefined cell, different identifier name is used because those 2 kinds of cell could not be mixed up
        if ([xyTableCell isKindOfClass:[XYDynamicTableCell class]]) {
            // Using a different cell identifier as accessoryView need to be updated
            cell = [self reusableCell:@"DynaCell" tableView:tableView atIndex:indexPath];
        } if ([xyTableCell isKindOfClass:[XYButtonTableCell class]]){
            cell = [self reusableCell:@"BtnCell" tableView:tableView atIndex:indexPath];
        } else {
            // Otherwise use default identifier "Cell"
            cell = [self reusableCell:@"Cell" tableView:tableView atIndex:indexPath];
        }
    }
    
    // Common UITableViewCell property mapping
    // Reset cell text property to default value
    cell.textLabel.text = @"";
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = xyTableCell.backgroundColor;
    cell.accessoryType = xyTableCell.accessoryType;
    cell.selectionStyle = xyTableCell.selectionStyle;
    UITableViewCell* resultCell;
    if (xyTableCell.customizedCellForRow) {
        // Customized rendering, user to map cell property 
        resultCell = [((id<XYBaseUITableViewMethods>) _controller) customizedCell:xyTableCell uiTableViewCell:cell tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        // Render each predefined XYTableCell
        resultCell = [self renderXYTableCell:xyTableCell withUITableViewCell:cell ofTable:tableView atIndex:indexPath];
    }
//    resultCell.backgroundColor = [UIColor redColor];
    return resultCell;
}

/*
  Render predefined cell
 */
-(UITableViewCell*)renderXYTableCell:(XYTableCell*)xyTableCell withUITableViewCell:(UITableViewCell*)tableViewCell ofTable:(UITableView*)tableView atIndex:(NSIndexPath*)indexPath{
    
    // Remove all views in reusable cell
    for (UIView* view in tableViewCell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (xyTableCell.view != nil) {
        // Use customiezed view
        if (xyTableCell.viewAsBackgroundView) {
            #pragma mark - TODO if view as cell background view
            // Below logic not completed 
            
            tableViewCell = [self reusableCell:@"BGVCell" tableView:tableView atIndex:indexPath];
            [tableViewCell addSubview:xyTableCell.view];
        } else {
            // Render tableViewCell
            tableViewCell.contentView.clipsToBounds = YES;
            tableViewCell.clipsToBounds = YES;
            [tableViewCell.contentView addSubview:xyTableCell.view];
            
            [tableViewCell.contentView bringSubviewToFront:xyTableCell.view];
        }
    } else {
        // Use default if view or field is nil
        tableViewCell.textLabel.text = xyTableCell.text;
        tableViewCell.detailTextLabel.text = xyTableCell.detailText;
        if (xyTableCell.attributedText != nil) {
            tableViewCell.textLabel.attributedText = xyTableCell.attributedText;
        }
        if (xyTableCell.attributedDetailText != nil) {
            tableViewCell.detailTextLabel.attributedText = xyTableCell.attributedDetailText;
        }
    }
    //Config cell by TableCell class type
    [self configCell:xyTableCell cell:tableViewCell tableView:tableView index:indexPath];
    //[tableViewCell layoutSubviews];
    return tableViewCell;
}

/*
 Return reusable UITableViewCell by identifer
 */

-(UITableViewCell*)reusableCell:(NSString*)cellIdentifier tableView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell;
    
    @try {
        // Below API only available in iOS 6 above
        //cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    }
    @catch (NSException *exception) {
        // To back compatible with iOS 5, incase any exception(unrecognized selector) raised, call iOS 5 API
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    // If view controller is created by code not from storyboard, create cell
    if (cell == nil) {
        if (self.cellStyle == 0) {
            self.cellStyle = UITableViewCellStyleDefault;
        }
        // Create UITableViewCell object
        cell = [[UITableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:cellIdentifier];
        
    }
    return cell;
}

/*
  Config each predefined XYTableCell
 */
-(void)configCell:(XYTableCell*)xyTableCell cell:(UITableViewCell*)cell tableView:(UITableView*) tableView index:(NSIndexPath *)indexPath{
    if ([xyTableCell.field isKindOfClass:[XYInputTextField class]]) {
        // Mapping if text field is editable
        ((XYInputTextField*)xyTableCell.field).view.textField.enabled = xyTableCell.editable;
    }
    if ([xyTableCell.field isKindOfClass:[XYInputTextViewField class]]) {
        // Mapping if text view is editable
        ((XYInputTextViewField*)xyTableCell.field).
        view.textView.editable = xyTableCell.editable;
    }
    
    if ([xyTableCell.field isKindOfClass:[XYSelectionField class]]) {
    }
    
    if ([xyTableCell isKindOfClass:[XYSelectionItemTableCell class]]) {
        if ([_controller isKindOfClass:[XYSelectionListViewController class]]) {
            /*
              If current view is selection view(second screen), find out the selection field passed by main screen(first screen), based on the selection field value, make the checkmark on or off 
            */
            XYSelectionField* field = (XYSelectionField*)((XYSelectionListViewController*)_controller).advField;
            if (field.selectedIndexPath == nil || field.selectedIndexPath.count == 0) {
                // Nothing selected
                return;
            }
            // Find selected fields
            BOOL selected = NO;
            // Loop at the selected indexPath, if found, means it's selected
            for (NSIndexPath* selectedIndexPath in field.selectedIndexPath) {
                if (selectedIndexPath.row == indexPath.row) {
                    selected = YES;
                    break;
                }
            }
            // Put checkmark on selected field
            if (selected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
        
    }
    if ([xyTableCell isKindOfClass:[XYButtonTableCell class]]) {
        if ([xyTableCell.view isKindOfClass:[XYActivityIndicatorView class]]) {
            /*
             For "Load More" button, if the activity indicator is animating, when the table view cell refreshed, keep it animating
             */
            XYActivityIndicatorView* v = (XYActivityIndicatorView*)xyTableCell.view;
            if (v.animating) {
                v.animating = YES;
            }
        }
        
    }
    if ([xyTableCell isKindOfClass:[XYBubbleTableCell class]]) {
        
    }
    
    
    if ([xyTableCell isKindOfClass:[XYDynamicTableCell class]]) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        XYDynamicTableCell* sdtc = (XYDynamicTableCell*)xyTableCell;
        
        /*
          If accessory button ("More" / "Less") needed, add the image on the button.
          Even the XYDynamicTableCell support to show/hide header list, currently only footer list will be used in this case.
         */
        if (sdtc.showAccessoryButton) {
            // Load more/less icon
            UIImage* imgToExpanded = [UIImage imageNamed:@"more_24"];
            UIImage* imgToCollapse = [UIImage imageNamed:@"less_24"];
            
            UIButton* btn;
            // Rotate the button image up and down
            if (sdtc.isFooterExpanded) {
                if (imgToCollapse == nil) {
                    btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    btn.transform = CGAffineTransformMakeRotation(-90.0*M_PI/180.0);
                } else {
                    UIImageView* v = [[UIImageView alloc] initWithImage:imgToCollapse];
                    btn = [[UIButton alloc] initWithFrame:v.frame];
                    [btn setImage:imgToCollapse forState:UIControlStateNormal];
                }
                
            } else {
                if (imgToExpanded == nil) {
                    btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    btn.transform = CGAffineTransformMakeRotation(90.0*M_PI/180.0);
                } else {
                    UIImageView* v = [[UIImageView alloc] initWithImage:imgToExpanded];
                    btn = [[UIButton alloc] initWithFrame:v.frame];
                    [btn setImage:imgToExpanded forState:UIControlStateNormal];
                }
            }
            // Add selector target to button, so that it reacts when being clicked
            [btn addTarget:self action:@selector(onDynamicCellAccessoryBtnClicked:withEvent:) forControlEvents:UIControlEventTouchDown];
            cell.accessoryView = btn;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
        }
    }
    
    if ([xyTableCell isKindOfClass:[XYValueHelpTableCell class]]) {
        {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [btn addTarget:self action:@selector(onDynamicCellAccessoryBtnClicked:withEvent:) forControlEvents:UIControlEventTouchDown];
            cell.accessoryView = btn;
        }
    }
}

/*
  Find out which row is clicked and trigger accessory button clicked event
 */
-(void)onDynamicCellAccessoryBtnClicked:(UIControl*)sender withEvent:(UIEvent*)event{
    // Find selected row and trigger table view method
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:self.tableView]];
    [self.tableView.delegate tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

/*
  Decide whether a XYTableCell can be selected
 */
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return indexPath if table cell is selectable
    if ([self isLoadMoreRow:indexPath]) {
        return loadMoreBtn.selectable ? indexPath : nil;
    }
    XYTableCell* f = [self.container xyTableCellAtIndexPath:indexPath];
    return f.selectable ? indexPath : nil;
}

/*
  Table view delegate method for row did selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the XYTableCell object selected
    XYTableCell* f;
    if ([self isLoadMoreRow:indexPath]) {
        f = loadMoreBtn;
    } else {
        f = [self.container xyTableCellAtIndexPath:indexPath];
    }
    [self didSelectXYTableCell:f onTableView:tableView atIndexPath:indexPath];
}

/*
  Logic for predefined XYTableCell
 */
-(void)didSelectXYTableCell:(XYTableCell *)xyTableCell onTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    // Only selectable XYTableCell will enter this method
    // Deselected row if autoDeseelct
    if (xyTableCell.autoDeselected) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    // If row is "Load More" button, call user defined logic of loading more data and animate the indicator
    if ([xyTableCell.name isEqualToString:@"_loadMore_"]) {
        // Predefined loadMore button clicked, start animation
        ((XYActivityIndicatorView*)xyTableCell.view).label.text = @"Loading...";
        ((XYActivityIndicatorView*)xyTableCell.view).animating = YES;
        // To avoid second clicking, set it to unselectable
        xyTableCell.selectable = NO;
        // Check whether customized method available, if available, call it
        if ([_controller conformsToProtocol:@protocol(XYBusyProcessorDelegate) ]) {
            [((id<XYBusyProcessorDelegate>)_controller)
             setShowActivityIndicatorView:NO];
            [((id<XYBusyProcessorDelegate>)_controller) performBusyProcess:^XYProcessResult *{
                loadMoreInProgress = YES;
                if ([_controller conformsToProtocol:@protocol(XYLoadMore)]) {
                    [((id<XYLoadMore>)_controller) loadMoreData];
                }
                // Reset button text and stop animation
                [((XYActivityIndicatorView*)xyTableCell.view).label performSelectorOnMainThread:@selector(setText:) withObject:@"More..." waitUntilDone:YES];
                ((XYActivityIndicatorView*)xyTableCell.view).animating = NO;
                xyTableCell.selectable = YES;
                loadMoreInProgress = NO;
                [((id<XYBusyProcessorDelegate>)_controller)
                 setShowActivityIndicatorView:YES];
                return nil;
            }];
        }
        return;
    }
    /*
      If onClicked logic provided for XYButtonTableCell, execute it directly
     */
    if ([xyTableCell isKindOfClass:[XYButtonTableCell class]]) {
        XYButtonTableCell* btnCell = (XYButtonTableCell*)xyTableCell;
        if (btnCell.onClickSelector != nil) {
            [btnCell.onClickSelector performSelector];
            return;
        }
    }
    
    if ([xyTableCell isKindOfClass:[XYDynamicTableCell class]]) {
        XYDynamicTableCell* dynamicTableCell = (XYDynamicTableCell*)xyTableCell;
        if (dynamicTableCell.clickToFold) {
            [self accessoryButtonTapped:xyTableCell onTableView:tableView atIndexPath:indexPath];
        }
    }
    
    
    
    [((id<XYBaseUITableViewMethods>) _controller) onSelectXYTableCell:xyTableCell atIndexPath:indexPath];
    
    /*
      For selection table, if navigation controller available, push the selection list view, otherwise show view in modal mode
     */
    if (([xyTableCell isKindOfClass:[XYSelectionTableCell class]] && ((XYSelectionTableCell*)xyTableCell).triggerByAccessoryButton == NO)|| [xyTableCell isKindOfClass:[XYValueHelpTableCell class]]) {
        XYSelectionTableCell* stf = (XYSelectionTableCell*)xyTableCell;
        XYAdvField* sf = (XYAdvField*)stf.field;
        UIViewController* viewController = [sf subViewController];

        if ([xyTableCell isKindOfClass:[XYValueHelpTableCell class]]) {
            ((XYDynaSearchFieldViewController*)viewController).searchBar.text = ((XYInputTextViewView*)stf.field.view).textView.text;
            [((XYDynaSearchFieldViewController*)viewController) searchBar:((XYDynaSearchFieldViewController*)viewController).searchBar textDidChange:((XYDynaSearchFieldViewController*)viewController).searchBar.text];
        }
        
        UIPopoverController* popOverController;

        if ([self.controller isKindOfClass:[XYBaseUITableViewController class]]) {
            popOverController = ((XYBaseUITableViewController*)self.controller).popOverController;
        }
        
        if ([self.controller isKindOfClass:[XYBaseUIViewController class]]) {
            popOverController = ((XYBaseUIViewController*)self.controller).popOverController;
        }
        
        CGSize popoverContentSize = popOverController.popoverContentSize;
        
        if (stf.isPopOverOptionView == YES && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [sf showPopoverInputView];
            return;
        }
        
        if (self.controller.navigationController != nil) {
            
            popoverContentSize.height -= 37*2;//self.controller.navigationController.navigationBar.frame.size.height;
            
            if ([viewController isKindOfClass:[XYBaseUITableViewController class]]) {
                ((XYBaseUITableViewController*)viewController).popOverController = popOverController;
            }
            
            if ([viewController isKindOfClass:[XYBaseUIViewController class]]) {
                ((XYBaseUIViewController*)viewController).popOverController = popOverController;
            }
            
            [self.controller.navigationController pushViewController:viewController animated:YES];
        } else {
            [self.controller presentViewController:viewController animated:YES completion:nil];
        }
    }
    
    if ([xyTableCell isKindOfClass:[XYSelectionTableCell class]] && ((XYSelectionTableCell*)xyTableCell).triggerByAccessoryButton == YES) {
        return;
    }
    
    /*
      If selection item selected, populate selected index value into XYSelectionField
      If it's single selection, back to selection view
      If it's multiply selection, only reload item list for selected item
     */
    if ([xyTableCell isKindOfClass:[XYSelectionItemTableCell class]]) {
        if ([_controller isKindOfClass:[XYSelectionListViewController class]]) {
            XYSelectionListViewController* slvc = (XYSelectionListViewController*)_controller;
            XYSelectionField* sf = (XYSelectionField*)slvc.advField;
            BOOL selected = YES;
            for (NSIndexPath* index in sf.selectedIndexPath) {
                if (index.row == indexPath.row) {
                    selected = NO;
                }
            }
            if (sf.isSingleSelection) {
                // For single selection, the selected indexpath only contain 1 object
                if (selected) {
                    sf.selectedIndexPath = [NSMutableSet setWithObject:indexPath];
                } else {
                    sf.selectedIndexPath = [NSMutableSet new];
                    
                }
                // render selection field by value
                [sf renderFieldView];
                
                // If selection field has a callback for selection completed, call it
                if (sf.selectionCompletedSelector != nil) {
                    sf.selectionCompletedSelector.object = sf;
                    [sf.selectionCompletedSelector performSelector];
                }
                
                
                // Back to previous view
                UIViewController* v = nil;
                if (_controller.navigationController != nil) {
                    v = [_controller.navigationController popViewControllerAnimated:YES];
                }
                
                // If v is nil, no more view avialble in navigation controller, dismiss the view or popover view
                if (v == nil) {
                    if ((slvc.popOverController != nil && slvc.popOverController.isPopoverVisible) || slvc.advField.isPopOverOptionView == YES) {
                        [slvc.popOverController dismissPopoverAnimated:YES];
                        return;
                    } else {
                        [_controller dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                
            } else {
                // For mulitply selection, change selectedIndexPath set and reload cell to show the check mark
                if (selected) {
                    [sf.selectedIndexPath addObject:indexPath];
                } else {
                    [sf.selectedIndexPath removeObject:indexPath];
                }
                [sf renderFieldView];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
            }
        }
    }
    
    /*
      For XYExpandableTableCell, on selecting cell, expand or collapse the cell
     */
    if ([xyTableCell isKindOfClass:[XYExpandableTableCell class]]) {
        XYExpandableTableCell* etf = (XYExpandableTableCell*)xyTableCell;
        [tableView beginUpdates];
        etf.isExpanded = !etf.isExpanded;
        [tableView endUpdates];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
}

/*
  Return height of each XYTableCell
  Need to check/add logic if there is any new view in XYTableCell
  Since view will be resized here, for each view UIViewAutoresizingNone should be set
  view.autoresizingMask = UIViewAutoresizingNone;
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    // Get new frame of table content view
    CGRect contentFrame = [self tableViewContentViewFrame];
    
    if ([self isLoadMoreRow:indexPath]) {
        loadMoreBtn.view.frame = contentFrame;
        return loadMoreBtn.height;
    }
    
    // For XYDummyTableCell or customizedCellForRow is YES, return customized height
    XYTableCell* f = [_container xyTableCellAtIndexPath:indexPath];
    
    if ([f isKindOfClass:[XYDummyTableCell class]] || f.customizedCellForRow) {
        // If height of cell is 0, check customized method
        // Also if view is nil, check customized method, otherwise default value 44 in XYTableCell will be used
        if (f.height == 0 && f.view == nil) {
            return [((id<XYBaseUITableViewMethods>) _controller) customizedTableView:tableView heightForRowAtIndexPath:indexPath];
        } else {
            return f.height;
        }
    }
    
    // For XYExpandableTableCell, return the height based on expanded flag
    if ([f isMemberOfClass:[XYExpandableTableCell class]]) {
        XYExpandableTableCell* etf = (XYExpandableTableCell*)f;
        if (etf.isExpanded) {
            return etf.maxHeight;
        } else {
            return etf.minHeight;
        }
    }
    
    // For all view inherited from XYBaseView, resizing the frame
    if ([f.view isKindOfClass:[XYBaseView class]]) {
        f.view.frame = [self tableViewContentViewFrame:f.view.frame];
    }
    
    if ([f.view isKindOfClass:[XYBubbleView class]]) {
        f.view.frame = [self tableViewContentViewFrame:f.view.frame];
    }
    
    // Resizing the UILabel view
    if ([f isKindOfClass:[XYButtonTableCell class]]) {
        f.view.frame = contentFrame;
    }
    
    // By default return height defined in XYTableCell
    return f.height;
}

/*
  Return whether XYTableCell is editable.
 */
#pragma mark - Potential problem: TableView editable and view on XYTableCell editable is different
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_enableSwipeToDelete) {
        XYTableCell* f = [_container xyTableCellAtIndexPath:indexPath];
        return f.editable;
    } else {
        if (tableView.isEditing) {
            XYTableCell* f = [_container xyTableCellAtIndexPath:indexPath];
            return f.editable;
        } else {
            return NO;
        }
    }
}

/*
  Return tableview cell editing sytle
 */
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    // No editing style for "Load More" button
    if ([self isLoadMoreRow:indexPath]) {
        return UITableViewCellEditingStyleNone;
    }
    XYTableCell* f = [_container xyTableCellAtIndexPath:indexPath];
    return f.editingStyle;
}

/*
  Return whether XYTableCell is movable
 */
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    XYTableCell* f = [_container xyTableCellAtIndexPath:indexPath];
    if ([f isKindOfClass:[XYDynamicTableCell class]]) {
        return NO;
    }
    return f.movable;
}

/*
  Logic for moving/switching 2 XYTableCell
 */
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    XYTableCell* srcCell = [_container xyTableCellAtIndexPath:sourceIndexPath];
    XYTableCell* destCell = [_container xyTableCellAtIndexPath:destinationIndexPath];
    // Not allow to move XYDynamicTableCell
    if ([srcCell isKindOfClass:[XYDynamicTableCell class]] || [destCell isKindOfClass:[XYDynamicTableCell class]]) {
        [self.tableView reloadData];
        return;
    }
    // Not allow to move cell under different super cell
    if (srcCell.superCell != nil && [srcCell.superCell isKindOfClass:[XYDynamicTableCell class]] && srcCell.superCell != destCell.superCell) {
        [self.tableView reloadData];
        return;
    }
    // Not allow to move cell under different section
    if (sourceIndexPath.section != destinationIndexPath.section) {
        [self.tableView reloadData];
        return;
    }
    
    // Move item in container
    [_container moveTableCellFrom:sourceIndexPath to:destinationIndexPath];
    
    // Call customized logic when item moved
    [((id<XYBaseUITableViewMethods>) _controller) moveCell:srcCell atIndexPath:sourceIndexPath to:destCell atIndexPath:destinationIndexPath];
}

/*
  Logic for commiting editing style
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    XYTableCell* cell = [_container xyTableCellAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove item from container
        [_container removeXYTableCellAtIndexPath:indexPath];
        // If item in XYDynamicTableCell removed, calculate the row index to reload
        if (cell.superCell != nil && [cell.superCell isKindOfClass:[XYDynamicTableCell class]]) {
            XYDynamicTableCell* superCell = (XYDynamicTableCell*)cell.superCell;
            [self.tableView reloadData];
            NSInteger cellRowCount = [superCell actualCellArray].count;
            NSInteger reloadRow = indexPath.row > cellRowCount? cellRowCount : indexPath.row;
            NSIndexPath* idx = [NSIndexPath indexPathForRow:reloadRow - 1 inSection:indexPath.section];
            // Refresh the row
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:idx] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            // Delete & Refresh the row
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    // Call customized method
    [((id<XYBaseUITableViewMethods>) _controller) customizedTableView:tableView commitEditingStyle:editingStyle forXYTableCell:cell forRowAtIndexPath:indexPath];
}

/*
  Return header title of each section
 */
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray* sections = [_container actualSectionArray];
    XYTableSection* sec = [sections objectAtIndex:section];
    if (sec.headerView != nil) {
        // View is provided
        return @"title";
    } else {
        return sec.headerTitle;
    }
}

/**
 Return header title view
 */
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray* sections = [_container actualSectionArray];
    XYTableSection* sec = [sections objectAtIndex:section];
    return sec.headerView;
}


/**
 Return header view height
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray* sections = [_container actualSectionArray];
    XYTableSection* sec = [sections objectAtIndex:section];
    if (sec.headerView != nil) {
        return sec.headerView.bounds.size.height;
    } else if (![XYUtility isBlank:sec.headerTitle]){
        return kDefaultTableViewHeaderHeight;
    } else {
        return 0;
    }
}

/*
  Return footer title of each section
 */
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    XYTableSection* sec = [[_container actualSectionArray] objectAtIndex:section];
    if (sec.footerView != nil) {
        return @"footer";
    } else {
        return sec.footerTitle;
    }
}

/**
 Return footer title view
 */
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray* sections = [_container actualSectionArray];
    XYTableSection* sec = [sections objectAtIndex:section];
    return sec.footerView;
}

/**
 Return footer view height
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSArray* sections = [_container actualSectionArray];
    XYTableSection* sec = [sections objectAtIndex:section];
    if (sec.footerView != nil) {
        return sec.footerView.bounds.size.height;
    } else if (![XYUtility isBlank:sec.footerTitle]){
        return kDefaultTableViewFooterHeight;
    } else {
        return 0;
    }
}

/*
  Logic when table view scrolling
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // Resign all first responder in table view cell
    [self resignAllFirstResponder];
    
    // Call customized method
    if (_controller != nil && [_controller conformsToProtocol:@protocol(XYBaseUITableViewMethods)]) {
        [((id<XYBaseUITableViewMethods>)_controller) customizedScrollViewWillBeginDragging:scrollView];
    }
    
    // Calculate scroll distance and show top/bottom view
    float y = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height : scrollView.frame.size.height;
    // "Pull up to load"
    if (_bottomViewEnabled && _bottomView.status != XYViewStatusExecuting) {
        if (_bottomView == nil) {
            _bottomView = [[XYSideView alloc] initWithFrame:CGRectMake(0, y, scrollView.frame.size.width, 40)];
            _bottomView.loadingDesc = @"Loading...";
            _bottomView.readyDesc = @"Pull up to load more...";
            _bottomView.releaseDesc = @"Release to load more...";
            
        } else {
            _bottomView.frame = CGRectMake(0, y, scrollView.frame.size.width, 40);
            [_bottomView removeFromSuperview];
        }
        [scrollView addSubview:_bottomView];
        
    }
    // "Drill down to refresh"
    if (_topViewEnabled && _topView.status != XYViewStatusExecuting) {
        if (_topView == nil) {
            _topView = [[XYSideView alloc] initWithFrame:CGRectMake(0, -40, scrollView.frame.size.width, 40)];
            _topView.loadingDesc = @"Loading...";
            _topView.readyDesc = @"Pull down to refresh...";
            _topView.releaseDesc = @"Release to refresh...";
        } else {
            _topView.frame = CGRectMake(0, -40, scrollView.frame.size.width, 40);
            [_topView removeFromSuperview];
        }
        
        [scrollView addSubview:_topView];
    }
    dragStartPoint = scrollView.contentOffset;
}

/*
  Decide when to show top/bottom view
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint p = scrollView.contentOffset;
    float offsetY = p.y - dragStartPoint.y;
    if (scrollView.isDragging && _bottomViewEnabled && p.y > (scrollView.contentSize.height - scrollView.frame.size.height)) {
        if (_bottomView.status != XYViewStatusExecuting) {
            if (offsetY > _bottomView.frame.size.height + 10) {
                _bottomView.status = XYViewStatusReleaseToExecute;
            } else {
                _bottomView.status = XYViewStatusReadyToExecute;
            }
        }
    }
    if (scrollView.isDragging && _topViewEnabled && dragStartPoint.y <= 0.0) {
        if (_topView.status != XYViewStatusExecuting) {
            if (offsetY < -_topView.frame.size.height) {
                _topView.status = XYViewStatusReleaseToExecute;
            } else {
                _topView.status = XYViewStatusReadyToExecute;
            }
        }
    }
    
    if ([_container respondsToSelector:@selector(customizedScrollViewDidScroll:)]) {
        [((id<XYBaseUITableViewMethods>) _controller) customizedScrollViewDidScroll:scrollView];
    }
}

/*
  Decide top/bottom view status when scrolling ended
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_bottomViewEnabled && _bottomView.status == XYViewStatusReleaseToExecute) {
        _bottomView.status = XYViewStatusExecuting;
        [self performSelectorInBackground:@selector(bottomViewEvent) withObject:nil];
    }
    if (_topViewEnabled && _topView.status == XYViewStatusReleaseToExecute) {
        _topView.status = XYViewStatusExecuting;
        [self performSelectorInBackground:@selector(topViewEvent) withObject:nil];
    }
}

/*
  Trigger top view event
 */
-(void)topViewEvent{
    if ([_controller conformsToProtocol:@protocol(XYBaseUITableViewMethods)]) {
        [((id<XYBaseUITableViewMethods>)_controller) topViewEventTriggered];
    }
    _topView.status = XYViewStatusFinished;
}

/*
  Trigger bottom view event
 */
-(void)bottomViewEvent{
    if ([_controller conformsToProtocol:@protocol(XYBaseUITableViewMethods)]) {
        [((id<XYBaseUITableViewMethods>)_controller) bottomViewEventTriggered];
    }
    _bottomView.status = XYViewStatusFinished;
}

/*
  Logic for accessory button tapped
 */
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the XYTableCell
    XYTableCell* cell;
    if ([self isLoadMoreRow:indexPath]) {
        cell = loadMoreBtn;
    } else {
        cell = [self.container xyTableCellAtIndexPath:indexPath];
    }
    
    if ([cell isKindOfClass:[XYSelectionTableCell class]] && ((XYSelectionTableCell*)cell).triggerByAccessoryButton == YES) {
        XYSelectionTableCell* stf = (XYSelectionTableCell*)cell;
        XYAdvField* sf = (XYAdvField*)stf.field;
        UIViewController* viewController = [sf subViewController];
        
        UIPopoverController* popOverController;
        
        if ([self.controller isKindOfClass:[XYBaseUITableViewController class]]) {
            popOverController = ((XYBaseUITableViewController*)self.controller).popOverController;
        }
        
        if ([self.controller isKindOfClass:[XYBaseUIViewController class]]) {
            popOverController = ((XYBaseUIViewController*)self.controller).popOverController;
        }
        
        CGSize popoverContentSize = popOverController.popoverContentSize;
        
        if (stf.isPopOverOptionView == YES && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [sf showPopoverInputView];
            return;
        }
        
        if (self.controller.navigationController != nil) {
            
            popoverContentSize.height -= 37*2;//self.controller.navigationController.navigationBar.frame.size.height;
            
            if ([viewController isKindOfClass:[XYBaseUITableViewController class]]) {
                ((XYBaseUITableViewController*)viewController).popOverController = popOverController;
            }
            
            if ([viewController isKindOfClass:[XYBaseUIViewController class]]) {
                ((XYBaseUIViewController*)viewController).popOverController = popOverController;
            }
            
            [self.controller.navigationController pushViewController:viewController animated:YES];
        } else {
            [self.controller presentViewController:viewController animated:YES completion:nil];
        }

    }
    
    if ([cell isKindOfClass:[XYValueHelpTableCell class]]) {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    
    // Logic for predefined XYTableCell accessory button tapped
    [self accessoryButtonTapped:cell onTableView:tableView atIndexPath:indexPath];
    
    // Customized method call
    if ([_controller respondsToSelector:@selector(onAccessoryButtonTapped:onTableView:atIndexPath:)]) {
        [((id<XYBaseUITableViewMethods>) _controller) onAccessoryButtonTapped:cell onTableView:tableView atIndexPath:indexPath];
    }
    
}

/*
  Logic for predefined XYTableCell accessory button tapped
 */
-(void)accessoryButtonTapped:(XYTableCell*)xyTableCell onTableView:(UITableView*) tableView atIndexPath:(NSIndexPath*) indexPath{
    // For XYDynamicTableCell accessory button tapped
    if ([xyTableCell isKindOfClass:[XYDynamicTableCell class]]) {
        XYDynamicTableCell* dtf = (XYDynamicTableCell*)xyTableCell;
        NSInteger headerAddedRowCount = 0;
        NSInteger headerRemovedRowCount = 0;
        NSInteger headerCount = [dtf countOfHeaderExtraCell];
        if (dtf.showHeaderExtraCell) {
            if (!dtf.isHeaderExpanded) {
                // If header list is not displayed, insert rows
                NSMutableArray* indexs = [NSMutableArray new];
                for (int i = 0; i< headerCount - dtf.headerDisplayRowNumber; i++) {
                    XYTableCell* f = [dtf headerExtraCellAtRow:i];
                    if (f.visible == YES) {
                        // If cell is already visible, return without reloading
                        continue;
                    }
                    f.visible = YES;
                    // Insert new rows
                    NSIndexPath* index = [NSIndexPath indexPathForRow:indexPath.row + i inSection:indexPath.section];
//                    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
                    [indexs addObject:index];
                    headerAddedRowCount++;
                }
                [tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationTop];
            } else {
                // If header list is displayed, delete rows
                NSMutableArray* indexs = [NSMutableArray new];
                for (int i = 0; i< headerCount - dtf.headerDisplayRowNumber; i++) {
                    XYTableCell* f = [dtf headerExtraCellAtRow:i];
                    if (f.visible == NO) {
                        // If cell is already invisible, return without reloading
                        continue;
                    }
                    f.visible = NO;
                    // Remove rows
//                    NSIndexPath* index = [NSIndexPath indexPathForRow:indexPath.row - headerCount inSection:indexPath.section];
//                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
//                    headerRemovedRowCount++;
                    
                    NSIndexPath* index = [NSIndexPath indexPathForRow:indexPath.row - headerCount + i inSection:indexPath.section];
                    [indexs addObject:index];
                    headerRemovedRowCount++;
                }
                [tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationTop];
            }
            dtf.isHeaderExpanded = !dtf.isHeaderExpanded;
        }

        NSInteger footerCount = [dtf countOfFooterExtraCell];
        NSInteger headerRows = dtf.showHeaderExtraCell ? headerAddedRowCount : -headerRemovedRowCount;
        if (dtf.showFooterExtraCell) {
            if (!dtf.isFooterExpanded) {
                // Insert footer rows
                
                NSMutableArray* indexs = [NSMutableArray new];
                for (NSInteger i = dtf.footerDisplayRowNumber; i< footerCount; i++) {
                    XYTableCell* f = [dtf footerExtraCellAtRow:i];
                    if (f.visible == YES) {
                        continue;
                    }
                    f.visible = YES;
                    // Update onece with NSArray
                    NSIndexPath* index = [NSIndexPath indexPathForRow:indexPath.row + 1 + headerRows + i inSection:indexPath.section];
                    [indexs addObject:index];
                }
                [tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationTop];
                
            } else {
                // Remove footer rows
                NSMutableArray* indexs = [NSMutableArray new];
                for (NSInteger i = dtf.footerDisplayRowNumber; i< footerCount; i++) {
                    XYTableCell* f = [dtf footerExtraCellAtRow:i];
                    if (f.visible == NO) {
                        continue;
                    }
                    f.visible = NO;
                    
                    // Remove once by NSArray
                    NSIndexPath* index = [NSIndexPath indexPathForRow:indexPath.row + 1 + dtf.footerDisplayRowNumber + headerRows + i inSection:indexPath.section];
                    [indexs addObject:index];
                }
                [tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationTop];
            }
            dtf.isFooterExpanded = !dtf.isFooterExpanded;
        }
    }
}
/*
  Clear value of all XYTableCell in table view
 */
-(void)clearAllFields{
    NSEnumerator* enu = _container.fieldsDictionary.keyEnumerator;
    NSString* fn;
    XYTableCell* tableCell;
    while ((fn = enu.nextObject)) {
        tableCell = [_container.fieldsDictionary objectForKey:fn];
        [tableCell.field clearValue];
    }
}

/*
  Resign all first responder in table view
 */
-(void)resignAllFirstResponder{
    NSEnumerator* enu = _container.fieldsDictionary.keyEnumerator;
    NSString* fn;
    XYTableCell* TableCell;
    while ((fn = enu.nextObject)) {
        TableCell = [_container.fieldsDictionary objectForKey:fn];
        [TableCell resignFirstResponder];
    }
}

/*
  Find tableView object in controller
 */
-(UITableView*)tableView{
    if (_tableView != nil) {
        return _tableView;
    } else if (self.controller != nil) {
        if ([self.controller isKindOfClass:[UITableViewController class]]) {
            return ((UITableViewController*)self.controller).tableView;
        }
    }
    return nil;
}

/*
  Find navigation controller by tableView object
 */
-(UINavigationController*)findNavigationControllerByTableView:(UITableView*)tableView{
    if (self.controller != nil) {
        if (self.controller.navigationController != nil) {
            return self.controller.navigationController;
        }
    }
    
    UIResponder* responder = tableView;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UINavigationController class]]) {
            UINavigationController* controller = (UINavigationController*) responder;
            return controller;
        }
    }
    return nil;
}

/*
  Find UIViewController by tableView object
 */
-(UIViewController*)findUIViewControllerByTableView:(UITableView*)tableView{
    if (self.controller != nil) {
        return self.controller;
    }
    
    UIResponder* responder = tableView;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            UIViewController* controller = (UIViewController*) responder;
            return controller;
        }
    }
    return nil;
}

/*
  Return predefined table view cell frame
 */
-(CGRect)tableViewCellFrame{
    CGRect frame = CGRectZero;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // For iphone
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            frame = CGRectMake(0, 46, self.tableView.frame.size.height, 44);
        } else {
            frame = CGRectMake(0, 10, self.tableView.frame.size.width, 44);
        }
    } else {
        // For ipad
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            frame = CGRectMake(0, 30, self.tableView.frame.size.height, 44);
        } else {
            frame = CGRectMake(0, 10, self.tableView.frame.size.width, 44);
        }
    }
    return frame;
}



/*
 Return predefined table cell content view frame base on device type, orientation mode, table view style and fixed height
 */

-(CGRect)tableViewContentViewFrameWithHeight:(CGFloat)height{
    return [self tableViewContentViewFrame:CGRectMake(0, 0, 0, height)];
}


/*
  Return predefined table cell content view frame base on device type, orientation mode, table view style
  Notice:
  Default height is 44
 */

-(CGRect)tableViewContentViewFrame{
    return [self tableViewContentViewFrame:CGRectMake(0, 0, 0, 44)];
}

/*
  Return predefined table cell content view frame base on device type, orientation mode, table view style
  Notice:
  If embeded in navigation controller, when changed to landscape, the width and height is different
 */
-(CGRect)tableViewContentViewFrame:(CGRect) f{
    CGRect frame = CGRectZero;
    float height = f.size.height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // For iphone
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            // In landscape mode
            switch (self.tableView.style) {
                case UITableViewStylePlain:{
                    if ([_controller isKindOfClass:[UITableViewController class]]) {
                        if (_controller.navigationController == nil) {
                            frame = CGRectMake(0, 0, self.tableView.frame.size.height, height);
                        } else {
                            frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                        }
                        
                    } else {
                        frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                    }
                }
                    break;
                case UITableViewStyleGrouped:{
                    if ([_controller isKindOfClass:[UITableViewController class]]) {
                        if (_controller.navigationController == nil) {
                            if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.height-20, height);
                            } else {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.height, height);
                            }
                        } else {
                            if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.width-20, height);
                            } else {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                            }
                            
                            
                        }
                    } else {
                        frame = CGRectMake(0, 0, self.tableView.frame.size.width-20, height);
                    }
                }
                    break;
                default:
                    break;
            }
          
        } else {
            // In portrait mode
            switch (self.tableView.style) {
                case UITableViewStylePlain:{
                    frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                }
                    break;
                case UITableViewStyleGrouped:{
                    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
                        frame = CGRectMake(0, 0, self.tableView.frame.size.width-18, height);
                    } else {
                        frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                    }
                }
                default:
                    break;
            }
        }
    } else {
        // For ipad
        if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            // In landscape mode
            switch (self.tableView.style) {
                case UITableViewStylePlain:{
                    if ([_controller isKindOfClass:[UITableViewController class]]) {
                        if (_controller.navigationController == nil) {
                            frame = CGRectMake(0, 0, self.tableView.frame.size.height, height);
                        } else {
                            frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                        }
                    } else {
                        frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                    }
                }
                    break;
                case UITableViewStyleGrouped:{
                    if ([_controller isKindOfClass:[UITableViewController class]]) {
                        if (_controller.navigationController == nil) {
                            if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.height-90, height);
                            } else {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.height, height);
                            }
                        } else {
                            if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.width-90, height);
                            } else {
                                frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                            }
                        }
                        
                    } else {
                        float marginWidth = [self groupedCellMarginWithTableWidth:self.tableView.frame.size.width];
                        frame = CGRectMake(0, 0, self.tableView.frame.size.width - marginWidth * 2, height);
                    }
                }
                    break;
                default:
                    break;
            }
            
        } else {
            // In portrait mode
            switch (self.tableView.style) {
                case UITableViewStylePlain:{
                    frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
                }
                    break;
                case UITableViewStyleGrouped:{
                    float marginWidth = [self groupedCellMarginWithTableWidth:self.tableView.frame.size.width];
                    frame = CGRectMake(0, 0, self.tableView.frame.size.width - marginWidth * 2, height);
                }
                    break;
                    
                default:
                    break;
            }
 
        }
    }
    return frame;
}

/*
  Calculate the margine for table view grouped style
 */
-(float)groupedCellMarginWithTableWidth:(float)tableViewWidth{
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        return 0;
    }
    float marginWidth;
    if (tableViewWidth > 20) {
        if (tableViewWidth < 400) {
            marginWidth = 10;
        } else {
            marginWidth = MAX(31, MIN(45, ceilf(tableViewWidth * 0.06)));
        }
    } else {
        marginWidth = tableViewWidth - 10;
    }
    return marginWidth;
}

// To do

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSMutableArray* a = [NSMutableArray new];
//    NSUInteger count = [self.container actualSectionArray].count;
//    if (count == 1) {
//        XYTableSection* s = [[self.container actualSectionArray] objectAtIndex:0];
//        count = [s actualCellArray].count;
//    }
//    
//    
//    for (int i = 0; i < count; i+=10) {
//        [a addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//    return a;
//    
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    NSLog(@"%@ %d",title,index);
//    if (index != 0) {
//        if ([self.container actualSectionArray].count == 1) {
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index*10 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        } else{
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
//        
//    }
//    return index;
//}

@end

