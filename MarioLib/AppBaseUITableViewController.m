//
//  AppBaseUITableViewController.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/5/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "AppBaseUITableViewController.h"

@interface AppBaseUITableViewController ()

@end

@implementation AppBaseUITableViewController
{
    XYNotificationView* _notiView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _notiView = [[XYNotificationView alloc] initWithTitle:@"Show something long long long long text adlfkja ldaskfj" message:nil delegate:nil];
    _notiView.delayAnimationDuration = 0;
   
}

//-(void)turnOnBusyFlag{
//    [_notiView showInViewController:self];
//}
//
//-(void)turnOffBusyFlag{
//    [_notiView dismiss];
//}

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
