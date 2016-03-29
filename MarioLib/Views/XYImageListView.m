//
//  ImageListView.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 1/20/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "XYImageListView.h"

@implementation XYImageListView
{
    CGFloat _startX;
    CGSize _size;
    CGSize _imgSize;
}
@synthesize imageList = _imageList;
@synthesize startX = _startX;
-(id)init{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _startX = 0;
    _size = CGSizeMake(5, 5);
    _imgSize = CGSizeMake(40, 40);
}

-(void)renderView{
    CGPoint p = CGPointZero;
    p.x = _startX == 0 ? _size.width : _startX;
    p.y = _size.height;
    for (UIView* view in _imageList) {
        if (p.x + _imgSize.width + _size.width >= self.frame.size.width) {
            p.x = _size.width;
            p.y += _imgSize.height + _size.height;
        }
        view.frame = CGRectMake(p.x, p.y, _imgSize.width, _imgSize.height);
        p.x += _imgSize.width + _size.width;
        [self addSubview:view];
    }
    CGFloat height = p.y + _imgSize.height + _size.height;
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
