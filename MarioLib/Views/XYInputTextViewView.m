//
//  XYInputTextViewView.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYInputTextViewView.h"

@implementation XYInputTextViewView
@synthesize label;
@synthesize textView;
@synthesize stickToTextView = _stickToTextView;
@synthesize textSize = _textSize;
@synthesize textViewAligment = _textViewAligment;
-(id)init{
    if (self = [super init]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset{
    if (self = [super initWithFrame:frame contentInset:contentInset]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andRatio:(float) ratio{
    if (self = [super initWithFrame:frame andRatio:ratio]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andLeftWidth:(float)width{
    if (self = [super initWithFrame:frame andLeftWidth:width]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset andRatio:(float)ratio{
    if (self = [super initWithFrame:frame contentInset:contentInset andRatio:ratio]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame contentInset:(UIEdgeInsets)contentInset andLeftWidth:(float)width{
    if (self = [super initWithFrame:frame contentInset:contentInset andLeftWidth:width]) {
        [self renderInputTextViewView];
    }
    return self;
}

-(void)renderInputTextViewView{
    self.autoresizingMask = UIViewAutoresizingNone;
    CGRect f = self.labelContainerView.frame;
    f.size.height = 35;
    label = [[UILabel alloc] initWithFrame:f];
    label.adjustsFontSizeToFitWidth = NO;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [XYSkinManager instance].xyTableCellLabelColor;
    label.textAlignment = NSTextAlignmentRight;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.textContainerView.frame.size.width, self.textContainerView.frame.size.height)];
    textView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:16];
    textView.textColor = [XYSkinManager instance].xyTableCellTextColor;
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        textView.contentInset = UIEdgeInsetsMake(0, -8, 0, 0);
    } else {
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self.labelContainerView addSubview:label];
    [self.labelContainerView bringSubviewToFront:label];
    [self.textContainerView addSubview:textView];
    [self.textContainerView bringSubviewToFront:textView];
}

-(CGRect)adjustFrame:(CGRect)f{
    CGRect centerFrame = CGRectMake(_contentInset.left, _contentInset.top, f.size.width - _contentInset.left - _contentInset.right,f.size.height - _contentInset.top - _contentInset.bottom);
    
    float leftWidth;
    if (_ratio != 0) {
        leftWidth = floor(centerFrame.size.width * _ratio);
    } else {
        leftWidth = _leftWidth;
    }
    CGRect leftRect = CGRectZero;
    if (_labelContainerViewEnabled) {
        leftRect = CGRectMake(0, 0, leftWidth, centerFrame.size.height);
        
    } else {
        leftRect = CGRectMake(0, 0, 0, centerFrame.size.height);
    }
    
    CGRect rightRect = CGRectZero;
    if (_textContainerViewEnabled) {
        // Plus 5 pixel as seperator
        float x = leftRect.size.width == 0 ? 0 : leftRect.size.width + 5;
        
        // Right rect width will shrink for 5 pixel
        float width = leftRect.size.width == 0 ? centerFrame.size.width : centerFrame.size.width - leftRect.size.width - 5;
        rightRect = CGRectMake(x, 0, width, centerFrame.size.height);
    } else {
        rightRect = CGRectMake(leftRect.size.width, 0, 0, centerFrame.size.height);
    }

    
    CGSize constrainedSize;
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        constrainedSize = CGSizeMake(rightRect.size.width + self.textView.contentInset.left * 2, CGFLOAT_MAX);
    } else {
        constrainedSize = CGSizeMake(rightRect.size.width, CGFLOAT_MAX);
    }

    CGSize contentSize = [XYUtility sizeOfText:self.textView.text withFont:self.textView.font constrainedSize:constrainedSize];
    f.size.height = contentSize.height + _contentInset.top + _contentInset.bottom + 20;
    
    _textSize.width = contentSize.width + 5;
    _textSize.height = contentSize.height;
    
    return f;
}


-(void)setTextViewAligment:(NSTextAlignment)textViewAligment{
    _textViewAligment = textViewAligment;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if (self.stickToTextView) {
        
        [textView setFrame:CGRectMake(0, 0, self.textContainerView.frame.size.width, self.textContainerView.frame.size.height)];
        
        CGSize oldTextViewSize = CGSizeZero;
        CGSize newTextViewSize = CGSizeZero;
        
        oldTextViewSize = self.textView.frame.size;
        
        // Seems that for below iOS version 7.0, sizeToFit will not make frame bigger than current one, set height to MAX and let it to reduce the height
        if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
            
            if (self.textView.text != nil && ![self.textView.text isEqualToString:@""]) {
                CGRect f = self.textView.frame;
                f.size.height = CGFLOAT_MAX;
                self.textView.frame = f;
                [self.textView sizeToFit];
            }

        } else {
            [self.textView sizeToFit];
        }
        
        newTextViewSize = self.textView.frame.size;

        CGRect f = frame;
        f.size.height = newTextViewSize.height + _contentInset.top + _contentInset.bottom;
        
        // Additional height need to be added for portrait layout
        switch (self.layout) {
            case XYFieldViewLayoutLabelAtTopTextAtBottom:{
                f.size.height += 34;
            }
                break;
                
            default:
                break;
        }
        
        super.frame = f;

        // Strange issue happen in iOS 7.0
        // Add one pix to width will temporary fix it.
        CGRect f2 = f;
        f2.size.width = newTextViewSize.width + 1;
        self.textView.frame = f2;
        
    }
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        CGSize rvs = self.textView.frame.size;
        
        switch (_textViewAligment) {
            case NSTextAlignmentLeft:{
                
            }
                break;
            case NSTextAlignmentCenter:{
                CGPoint p = CGPointZero;
                p.x = (self.textContainerView.frame.size.width - rvs.width) / 2;
                self.textView.frame = CGRectMake(p.x, p.y, rvs.width, rvs.height);
            }
                
                break;
            case NSTextAlignmentRight:{
                CGPoint p = CGPointZero;
                p.x = self.textContainerView.frame.size.width - rvs.width;
                self.textView.frame = CGRectMake(p.x, p.y, rvs.width, rvs.height);
                
            }
                break;
            default:
                break;
        }
    }
}

// To render the layout
-(void)setLayout:(XYFieldViewLayout)layout{
    [super setLayout:layout];
    switch (layout) {
        case XYFieldViewLayoutLabelAtLeftTextAtRight:{
            label.textAlignment = NSTextAlignmentRight;
        }
            break;
        case XYFieldViewLayoutLabelAtTopTextAtBottom:{
            label.textAlignment = NSTextAlignmentLeft;
        }
            break;
        default:
            break;
    }
}


@end
