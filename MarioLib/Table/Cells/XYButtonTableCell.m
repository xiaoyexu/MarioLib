//
//  XYButtonTableCell.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYButtonTableCell.h"

@implementation XYButtonTableCell :XYTableCell
@synthesize onClickSelector = _onClickSelector;
@synthesize onClicklogicInProgress = _onClicklogicInProgress;

+(XYButtonTableCell*)cellWithName:(NSString*)name view:(UIView*)view{
    XYButtonTableCell* f;
    if (view == nil) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        label.font = [UIFont boldSystemFontOfSize:20];
//        label.textColor = [UIColor SAPGoldenButtonColor];
        label.textColor = [UIColor orangeColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingNone;
        f = [[XYButtonTableCell alloc] initWithView:label];
    } else {
        f = [[XYButtonTableCell alloc] initWithView:view];
    }
    
    f.name = name;
    f.selectable = YES;
    f.backgroundColor = [UIColor grayColor];//[UIColor SAPGreyButtonColor];
    return f;
}
+(XYButtonTableCell*)cellWithName:(NSString*)name xyField:(XYField*)field{
    XYButtonTableCell* f;
    if (field == nil) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        label.font = [UIFont boldSystemFontOfSize:20];
//        label.textColor = [UIColor SAPGoldenButtonColor];
        label.textColor = [UIColor orangeColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingNone;
        f = [[XYButtonTableCell alloc] initWithView:label];
    } else {
        f = [[XYButtonTableCell alloc] initWithXYField:field];
    }
    f.name = name;
    f.selectable = YES;
    f.backgroundColor = [UIColor grayColor];
    return f;
}

-(void)setText:(NSString *)text{
    _text = text;
    if ([self.view isKindOfClass:[UILabel class]]) {
        ((UILabel*)_view).text = text;
    }
}

-(void)addTarget:(id)target action:(SEL) selector{
    _onClickSelector = [[XYSelectorObject alloc] initWithSEL:selector target:target];
}
@end

