//
//  ImageListView.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 1/20/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYImageListView : UIView
@property (nonatomic, strong) NSArray* imageList;
@property (nonatomic) CGFloat startX;
-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(void)renderView;
@end
