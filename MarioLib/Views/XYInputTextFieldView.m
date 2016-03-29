//
//  XYInputTextFieldView.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYInputTextFieldView.h"

@implementation XYInputTextFieldView
@synthesize label;
@synthesize textField;

-(id)init{
    if (self = [super init]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset{
    if (self = [super initWithFrame:frame contentInset:contentInset]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andRatio:(float)ratio{
    if (self = [super initWithFrame:frame andRatio:ratio]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andLeftWidth:(float)width{
    if (self = [super initWithFrame:frame andLeftWidth:width]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andRatio:(float) ratio{
    if (self = [super initWithFrame:frame contentInset:contentInset andRatio:ratio]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets) contentInset andLeftWidth:(float) width{
    if (self = [super initWithFrame:frame contentInset:contentInset andLeftWidth:width]) {
        [self renderInputTextFieldView];
    }
    return self;
}

-(void)renderInputTextFieldView{
    self.autoresizingMask = UIViewAutoresizingNone;
    label = [[UILabel alloc] initWithFrame:self.labelContainerView.frame];
    label.adjustsFontSizeToFitWidth = NO;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [XYSkinManager instance].xyTableCellLabelColor;
//    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask =UIViewAutoresizingFlexibleWidth;
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, ((self.textContainerView.frame.size.height - 21) /2), self.textContainerView.frame.size.width - 10, 28)];
    } else {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, ((self.textContainerView.frame.size.height - 27) /2), self.textContainerView.frame.size.width - 10, 28)];
    }
    
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.textColor = [XYSkinManager instance].xyTableCellTextColor;
    textField.adjustsFontSizeToFitWidth = NO;
    
    [self.labelContainerView addSubview:label];
    [self.textContainerView addSubview:textField];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    switch (self.layout) {
        // Only resize the text field for landscape layout 
        case XYFieldViewLayoutLabelAtLeftTextAtRight:{
            if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
                textField.frame = CGRectMake(0, ((self.textContainerView.frame.size.height - 21) /2), self.textContainerView.frame.size.width - 10, 28);
            } else {
                textField.frame = CGRectMake(0, ((self.textContainerView.frame.size.height - 27) /2), self.textContainerView.frame.size.width - 10, 28);
            }
        }
            break;
        case XYFieldViewLayoutLabelAtTopTextAtBottom:{
            
        }
            break;
        default:
            break;
    }
    
   
}

// To render the layout
-(void)setLayout:(XYFieldViewLayout)layout{
    XYFieldViewLayout oldLayout = self.layout;
    [super setLayout:layout];
    CGRect f = self.frame;
    switch (layout) {
        // Landscape layout height is 34 pix shorter than portrait and make text aligment to right
        /*
               Label|Text
         */
        case XYFieldViewLayoutLabelAtLeftTextAtRight:{
            label.textAlignment = NSTextAlignmentRight;
            if (layout != oldLayout) {
                f.size.height -= 34;
                self.frame = f;
            }
        }
            break;
        // Portrait layout height is 34 pix higher than landscape and make text alignment to left
        /*
            Label
            ------
            Text
         */
        case XYFieldViewLayoutLabelAtTopTextAtBottom:{
            label.textAlignment = NSTextAlignmentLeft;
            if (layout != oldLayout) {
                f.size.height += 34;
                self.frame = f;
            }
        }
            break;
        default:
            break;
    }
}
@end