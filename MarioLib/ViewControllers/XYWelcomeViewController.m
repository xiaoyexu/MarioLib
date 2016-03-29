//
//  XYWelcomeViewController.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/3/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYWelcomeViewController.h"

@interface XYWelcomeViewController ()

@end

@implementation XYWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)enterAppAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:XYWelcomeViewControllerDismissNotification object:nil];
    if ([self.delegate respondsToSelector:@selector(didExitWelcomeView:)]) {
        [self.delegate didExitWelcomeView:self];
    }
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
