//
//  XYSelectionListViewController.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectionListViewController.h"

@interface XYSelectionListViewController ()

@end

@implementation XYSelectionListViewController
@synthesize advField = _advField;

-(id)initWithStyle:(UITableViewStyle)style andTableContainer:(XYTableContainer *)container XYStyle:(XYUITableViewStyle)XYStyle cellStyle:(UITableViewCellStyle)cellStyle andTitle:(NSString *)title{
    if (self = [super initWithStyle:style andTableContainer:container xyStyle:XYStyle cellStyle:cellStyle andTitle:title]) {
        
        okBtn = [XYTableCellFactory cellOfButton:@"okBtn" label:@"Ok"];
        okBtn.visible = NO;
        [self.tableDelegate.container addXYTableCell:okBtn Level:XYViewLevelWorkArea section:1];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController != nil) {
        if (!_advField.isPopOverOptionView) {
            UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
            self.navigationItem.leftBarButtonItem = backButton;
            self.tableView.editing = NO;
        }
        okBtn.visible = NO;
    } else {
        okBtn.visible = YES;
    }
    [self.tableView reloadData];
}

-(void)loadAdvFieldValue{
    
    
}

-(void)onSelectXYTableCell:(XYTableCell *)field atIndexPath:(NSIndexPath *)indexPath{
    if ([field.name isEqualToString:@"okBtn"]) {
        [self backAction];
    }
}

-(void)backAction{
    XYSelectionField* sf = (XYSelectionField*)self.advField;
    [sf renderFieldView];
    if (sf.selectionCompletedSelector != nil) {
        sf.selectionCompletedSelector.object = sf;
        [sf.selectionCompletedSelector performSelector];
    }
    
    UIViewController* v = nil;
    if (self.navigationController != nil) {
        v = [self.navigationController popViewControllerAnimated:YES];
        
    }
    // If v is nil, no more view avialble in navigation controller, dismiss the view or popover view
    if (v == nil) {
        if ((self.popOverController != nil && self.popOverController.isPopoverVisible) || self.advField.isPopOverOptionView == YES) {
            [self.popOverController dismissPopoverAnimated:YES];
            return;
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)customizedTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forXYTableCell:(XYTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([_advField isKindOfClass:[XYSelectionField class]]) {
            XYSelectionField* sf = (XYSelectionField*)_advField;
            if (sf.selectionItemDeletedSelector == nil) {
                return;
            }
            [sf clearValue];
            sf.selectionItemDeletedSelector.object = indexPath;
            [sf.selectionItemDeletedSelector performSelector];
        }
    }
}
@end

