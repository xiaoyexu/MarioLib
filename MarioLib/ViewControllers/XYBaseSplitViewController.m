//
//  XYBaseSplitViewController.m
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/15/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBaseSplitViewController.h"

@interface XYBaseSplitViewController ()

@end

@implementation XYBaseSplitViewController

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
	
    UIViewController* detailVC = [self detailViewController];
    if ([detailVC isKindOfClass:[UINavigationController class]]) {
        self.delegate = (id<UISplitViewControllerDelegate>)[((UINavigationController*)detailVC) topViewController];
    } else {
        self.delegate = (id<UISplitViewControllerDelegate>)detailVC;
    }
    
    
}

-(UIViewController*)masterViewController{
    NSInteger count = self.viewControllers.count;
    if (count >= 2) {
        UIViewController* masterVC = [self.viewControllers objectAtIndex:count - 2];
        return masterVC;
    }
    return nil;
}

-(UIViewController*)detailViewController{
    return [self.viewControllers lastObject];
}

-(void)setDetailViewController:(UIViewController *)vc{
    NSMutableArray* viewControllers = [NSMutableArray new];
    [viewControllers addObjectsFromArray:self.viewControllers];
    [viewControllers replaceObjectAtIndex:(self.viewControllers.count - 1) withObject:vc];
    self.viewControllers = viewControllers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
