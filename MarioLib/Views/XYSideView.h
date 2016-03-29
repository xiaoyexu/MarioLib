//
//  XYSideView.h
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/17/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDesighHeader.h"

@interface XYSideView : UIView
{
@protected
    UILabel* _label;
    UIActivityIndicatorView* _activityIndicator;
}
@property (nonatomic) BOOL animating;
@property (nonatomic,strong) NSString* loadingDesc;
@property (nonatomic,strong) NSString* readyDesc;
@property (nonatomic,strong) NSString* releaseDesc;
@property (nonatomic) XYViewStatus status;
@end
