//
//  XYUISegmentedControl.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/23/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYUISegmentedControl.h"

@implementation XYUISegmentedControl
@synthesize selectedView = _selectedView;
@synthesize separateView = _separateView;
@synthesize selectedFontColor = _selectedFontColor;
@synthesize unSelectedFontColor = _unSelectedFontColor;
@synthesize selectedTitleFont = _selectedTitleFont;
@synthesize unSelectedTitleFont = _unSelectedTitleFont;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
-(id)initWithItems:(NSArray *)items{
    if (self = [super initWithItems:items]) {
        
    }
    return self;
}

-(void)renderView{
    //    NSBackgroundColorAttributeName
    //    [self setTintColor:[UIColor clearColor]];
    
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    if (_selectedTitleFont != nil) {
        [attributes setObject:_selectedTitleFont forKey:NSFontAttributeName];
    }
    if (_selectedFontColor != nil) {
        [attributes setObject:_selectedFontColor forKey:NSForegroundColorAttributeName];
    }
    [self setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    attributes = [NSMutableDictionary new];
    if (_unSelectedTitleFont != nil) {
        [attributes setObject:_unSelectedTitleFont forKey:NSFontAttributeName];
    }
    if (_unSelectedFontColor != nil) {
        [attributes setObject:_unSelectedFontColor forKey:NSForegroundColorAttributeName];
    }
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (_separateView != nil) {
        CGFloat width = self.bounds.size.width / self.numberOfSegments;
        NSUInteger count = self.numberOfSegments - 1;
        for (int i = 1; i <= count; i++) {
            UIView* v = [self duplicateView:_separateView];
            CGRect f = CGRectMake(i * width - (_separateView.bounds.size.width/2.0), (self.bounds.size.height - _separateView.bounds.size.height)/2.0 , _separateView.bounds.size.width,_separateView.bounds.size.height);
            v.frame = f;
            [self addSubview:v];
            
        }
    }
}

-(void)valueChanged:(XYUISegmentedControl*)segmentCtrl{
    if (_selectedView != nil) {
        CGRect f = _selectedView.frame;
        f.size.width = self.bounds.size.width / self.numberOfSegments;
        f.origin.x = segmentCtrl.selectedSegmentIndex * f.size.width;
        _selectedView.frame = f;
        [self addSubview:_selectedView];
    }
}

-(UIView*)duplicateView:(UIView*)view{
    NSData* viewData = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:viewData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
