//
//  XYBaseSplitViewController.h
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/15/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYBaseSplitViewController : UISplitViewController
-(UIViewController*)masterViewController;
-(UIViewController*)detailViewController;
-(void)setDetailViewController:(UIViewController*) vc;
@end
