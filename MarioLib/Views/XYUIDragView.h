//
//  XYUIDragView.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 7/30/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBaseView.h"

@class XYUIDragView;

@protocol XYUIDragViewDelegate <NSObject>
@optional
-(void)dragView:(XYUIDragView*)dragView onIntersectsWithView:(UIView*)view;
-(void)dragView:(XYUIDragView*)dragView onReleaseView:(XYBaseView*)v;
-(void)dragView:(XYUIDragView*)dragControlView onReleaseView:(XYBaseView*)v inView:(UIView*)area;
@end

@protocol XYUIDragViewDataSource <NSObject>
@optional
-(NSArray*)dragViews;
-(NSArray*)dropAreas;
@end

@interface XYUIDragView : UIView<XYViewDelegate>
@property(nonatomic, strong) id<XYUIDragViewDelegate> delegate;
@property(nonatomic, strong) id<XYUIDragViewDataSource> dataSource;
-(void)reloadData;
@end
