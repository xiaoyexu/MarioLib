//
//  TestXYBaseUITableViewController.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 7/21/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "TestXYBaseUITableViewController.h"

@interface TestXYBaseUITableViewController ()

@end

@implementation TestXYBaseUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableDelegate.topViewEnabled = YES;
    self.tableDelegate.bottomViewEnabled = YES;
    [self buildCells];
    
}

-(void)buildCells{
    for (int i =0; i<20; i++) {
        NSString* s = [NSString stringWithFormat:@"Input %d",i];
        XYTableCell* cell = [XYTableCellFactory cellOfInputField:@"cell" label:s ratio:0.3];
        [self.tableDelegate.container addXYTableCell:cell];
    }
    [self.tableView reloadData];
}

-(void)topViewEventTriggered{
    sleep(2);
}

-(void)bottomViewEventTriggered{
    sleep(2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
