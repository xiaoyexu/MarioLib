//
//  ViewController.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 1/8/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UITableView* tableView;
    XYBaseUITableViewDelegate* delegate;
    XYTableCell* inputField;
    XYTableCell* inputField2;
    XYTableCell* inputField3;
    
    XYTableCell* standardTableViewCell;
    XYTableCell* exampleCell;
    XYTableCell* viewCell;
    
    XYTableCell* raiseExceptionCell;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // Set skin
    [XYSkinManager instance].navigationBarTitleFont = [UIFont systemFontOfSize:19];
    [XYSkinManager instance].navigationBarTitleColor = [UIColor redColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    
    delegate = [[XYBaseUITableViewDelegate alloc] initWithTableContainer:[XYTableContainer new]];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    delegate.controller = self;
    delegate.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    XYTableSection* section = [XYTableSection new];
    
    exampleCell = [XYTableCellFactory cellOfButton:@"example" label:@"See examples"];
//    exampleCell = [XYTableCellFactory cellOfInputField:@"input" label:@"Name" ratio:0.3];
    [section addCell:exampleCell];
    
    standardTableViewCell = [XYTableCellFactory cellOfButton:@"standardTableView" label:@"Standard TableVc"];
    [section addCell:standardTableViewCell];
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    v.backgroundColor = [UIColor greenColor];
    viewCell = [[XYTableCell alloc] initWithView:v];
//    viewCell.height = 30;
    [section addCell:viewCell];
    
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    v.backgroundColor = [UIColor redColor];
    viewCell = [[XYTableCell alloc] initWithView:v];
    //    viewCell.height = 30;
    [section addCell:viewCell];
    section.headerTitle = @"Section header";
    section.footerTitle = @"Section footer";
    
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    v.backgroundColor = [UIColor greenColor];
    raiseExceptionCell = [[XYTableCell alloc] initWithView:v];
    raiseExceptionCell.selectable = YES;
    raiseExceptionCell.name = @"re";
    [section addCell:raiseExceptionCell];
    
    [delegate.container addXYTableSection:section];

    [tableView reloadData];
}

-(void)onSelectXYTableCell:(XYTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([cell.name isEqualToString:@"re"]) {
        @throw [NSException exceptionWithName:@"Error" reason:@"Something is wrong" userInfo:nil];
    }
    if ([cell.name isEqualToString:@"standardTableView"]) {
        StandardTableViewController* stvc = [StandardTableViewController new];
        [self.navigationController pushViewController:stvc animated:YES];
    }
    if ([cell.name isEqualToString:@"example"]) {
        AllSampleViewController* asvc = [AllSampleViewController new];
        [self.navigationController pushViewController:asvc animated:YES];
    }
}

- (void)viewDidLoad2 {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[XYSkinManager instance] setStyle:XYSkinStyleUI5];
    
    NSLog(@"%@",[XYSkinManager instance].xyTableCellLabelColor);
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    
    delegate = [[XYBaseUITableViewDelegate alloc] initWithTableContainer:[XYTableContainer new]];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    delegate.controller = self;
    delegate.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    inputField = [XYTableCellFactory cellOfInputField:@"input" label:@"Name" ratio:0.3];
//    [delegate.container addXYTableCell:inputField Level:XYViewLevelWorkArea];
    
    XYTableSection* section = [XYTableSection new];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    view.backgroundColor = [UIColor greenColor];
//    section.headerTitle = @"abc";
//    section.headerView = view;
    section.footerTitle = @"Footer";
    [section addCell:inputField];
    
    
    inputField2 = [XYTableCellFactory cellOfInputField:@"input" label:@"Name2" ratio:0.3];
//    [delegate.container addXYTableCell:inputField Level:XYViewLevelWorkArea];
    [section addCell:inputField2];

    inputField3 = [XYTableCellFactory cellOfInputField:@"input" label:@"Name3" ratio:0.3];
//    [delegate.container addXYTableCell:inputField3 Level:XYViewLevelWorkArea];
    [section addCell:inputField3];
    
    
    [delegate.container addXYTableSection:section];
    
    section = [XYTableSection new];
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor redColor];
    section.headerTitle = @"abc";
    section.headerView = view;
    
    for (int i = 0; i<10; i++) {
        inputField = [XYTableCellFactory cellOfDatePicker:@"picker" label:@"peric" ratio:0.3];
        [section addCell:inputField];
    }

    
    inputField = [XYTableCellFactory cellOfInputField:@"age" label:@"Age" ratio:0.3];
    [section addCell:inputField];
    
    inputField = [XYTableCellFactory cellOfInputField:@"address" label:@"Address" ratio:0.3];
    [section addCell:inputField];
    [delegate.container addXYTableSection:section];
    
    [tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
