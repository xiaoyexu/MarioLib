//
//  XYAnimation.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 7/21/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYAnimation <NSObject>
@property (nonatomic, readonly,getter = isAnimating) BOOL animating;
-(void)startAnimating;
-(void)stopAnimating;
@end
