//
//  TestDragControlVc.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 7/29/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "TestDragControlVc.h"

@implementation TestDragControlVc

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    XYUIDragView* control = [[XYUIDragView alloc] initWithFrame:self.view.bounds];
    control.delegate = self;
    control.dataSource = self;
    [control reloadData];
    [self.view addSubview:control];
}

-(NSArray*)dragViews{
    CGRect original_f = CGRectMake(10, 50, 100, 100);
    XYBaseView* objectView = [[XYBaseView alloc] initWithFrame:original_f];
    objectView.backgroundColor = [UIColor yellowColor];
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    v.backgroundColor = [UIColor redColor];
    [objectView addSubview:v];
    return @[objectView];
}

-(NSArray*)dropAreas{
    UIView* buttonRight = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, 50, 60)];
    buttonRight.backgroundColor = [UIColor redColor];
    buttonRight.tag = 1;
    UIView* buttonLeft = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 150, 50, 60)];
    buttonLeft.backgroundColor = [UIColor greenColor];
    buttonLeft.tag = 2;
    
    UIView* anyView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    anyView.layer.borderColor = [UIColor blackColor].CGColor;
    anyView.layer.borderWidth = 1.0;
    
    
    return @[buttonRight,buttonLeft,anyView];
}


-(void)dragView:(XYUIDragView *)dragView onIntersectsWithView:(UIView *)view{
    NSLog(@"view touched %d",view.tag);
}

-(void)dragView:(XYUIDragView *)dragView onReleaseView:(XYBaseView *)v{
    [UIView animateWithDuration:0.4 animations:^{
        v.frame = CGRectMake(10, 50, 100, 100);
        UIView* sView = [v.subviews objectAtIndex:0];
        sView.frame = CGRectMake(0, 0, 100, 100);
        sView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dragView:(XYUIDragView *)dragControlView onReleaseView:(XYBaseView *)v inView:(UIView *)area{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect f = area.frame;
        f.size.width = f.size.height = 100;
        v.frame = f;
        UIView* sView = [v.subviews objectAtIndex:0];
        sView.frame = CGRectMake(0, 0, 100, 100);
        sView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
