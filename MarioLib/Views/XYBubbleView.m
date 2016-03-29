//
//  XYTextViewContainer.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 10/24/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBubbleView.h"

@implementation XYBubbleView
{
    UITextView* _textView;
    CAShapeLayer* shapeLayer;
}
@synthesize textView = _textView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize textViewAligment = _textViewAligment;
@synthesize paddingRight = _paddingRight;
@synthesize paddingLeft = _paddingLeft;
@synthesize bubbleStyle = _bubbleStyle;
@synthesize fromself = _fromself;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        //_textView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        _textView.backgroundColor = [UIColor clearColor];
        //textView.alpha = 0.5;
        _textView.scrollEnabled = NO;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.editable = NO;
        [self addSubview:_textView];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.textView.frame = CGRectMake(_paddingLeft, 0, frame.size.width - _paddingLeft - _paddingRight, frame.size.height);
    
    CGSize oldTextViewSize = self.textView.frame.size;
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        CGRect f = self.textView.frame;
        f.size.height = CGFLOAT_MAX;
        self.textView.frame = f;
    }
    
    [self.textView sizeToFit];
    CGRect f = frame;
    CGSize newTextViewSize = self.textView.frame.size;

    f.size.height += newTextViewSize.height - oldTextViewSize.height;
    [super setFrame:f];
    
    
    if ([UIDevice currentDevice].systemVersion.integerValue < 7.0) {
        CGSize constrainedSize = CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX);
        CGSize contentSize = [XYUtility sizeOfText:self.textView.text withFont:self.textView.font constrainedSize:constrainedSize];
        NSInteger numberOflines = 1;
        if (self.textView.font != nil) {
            numberOflines = floor( self.textView.frame.size.height / self.textView.font.leading);
        }
        
        if (numberOflines == 1) {
            
            contentSize = [self.textView.text sizeWithFont:self.textView.font];
            CGRect f = self.textView.frame;
            f.size.width = contentSize.width;
            f.size.width += 16;
            if (f.size.width < self.textView.frame.size.width) {
                self.textView.frame = f;
            }
        }
    }
    
    
    switch (_textViewAligment) {
        case NSTextAlignmentLeft:{
        }
            break;
        case NSTextAlignmentCenter:{
            CGPoint p = CGPointZero;
            CGSize rvs = self.textView.frame.size;
            p.x = _paddingLeft + (self.frame.size.width - _paddingLeft - _paddingRight- rvs.width) / 2;
            self.textView.frame = CGRectMake(p.x, p.y, rvs.width, rvs.height);
        }
            
            break;
        case NSTextAlignmentRight:{
            CGPoint p = CGPointZero;
            CGSize rvs = self.textView.frame.size;
            p.x = self.frame.size.width - _paddingRight - rvs.width;
            self.textView.frame = CGRectMake(p.x, p.y, rvs.width, rvs.height);
            
        }
            break;
        default:
            break;
    }
    
    
}

-(void)setBackgroundImageView:(UIImageView *)backgroundImageView{
    [_backgroundImageView removeFromSuperview];
    _backgroundImageView = backgroundImageView;
    [_textView insertSubview:_backgroundImageView atIndex:0];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_bubbleStyle == XYBubbleCellStyleUI5) {
        
        // Draw UI5 style bubble
        [shapeLayer removeFromSuperlayer];
        shapeLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect b = _backgroundImageView.bounds;
        if (_fromself) {
            // Adjustment
            b.origin.x = 5;
            b.origin.y = 5;
            b.size.width -= 7;
            b.size.height -=5;
            float r = 8;
            
            CGPathMoveToPoint(path, NULL, b.origin.x + r, b.origin.y);
            CGPathAddArcToPoint(path, NULL, b.origin.x + b.size.width - r, b.origin.y, b.origin.x + b.size.width - r, b.origin.y + r, r);

            CGPathAddArcToPoint(path, NULL, b.origin.x + b.size.width - r, b.origin.y + b.size.height, b.origin.x + b.size.width, b.origin.y + b.size.height, r);

            CGPathAddArcToPoint(path, NULL, b.origin.x, b.origin.y + b.size.height, b.origin.x, b.origin.y, r);

            CGPathAddArcToPoint(path, NULL, b.origin.x, b.origin.y, b.origin.x + r, b.origin.y, r);
            
            [shapeLayer setFillColor:[XYUtility sapBlueColor].CGColor];
            _textView.textColor = [UIColor whiteColor];
        } else {
            
            // Adjustment
            b.origin.x = 0;
            b.origin.y = 5;
            b.size.width -= 10;
            float r = 8;
            
            CGPathMoveToPoint(path, NULL, b.origin.x + 2*r, b.origin.y);
        
            CGPathAddArcToPoint(path, NULL, b.origin.x + b.size.width + r, b.origin.y, b.origin.x + b.size.width + r, b.origin.y + b.size.height, r);
            
            CGPathAddArcToPoint(path, NULL, b.origin.x + b.size.width + r, b.origin.y + b.size.height - r, b.origin.x, b.origin.y + b.size.height, r);
            
            CGPathAddLineToPoint(path, NULL, b.origin.x, b.origin.y + b.size.height - r);
            
            CGPathAddArcToPoint(path, NULL, b.origin.x + r, b.origin.y + b.size.height - r, b.origin.x + r, b.origin.y + r, r);
            
            CGPathAddArcToPoint(path, NULL, b.origin.x + r, b.origin.y, b.origin.x + r + r, b.origin.y, r);
            
            [shapeLayer setFillColor:[XYUtility sapMessageTextLightGrayColor].CGColor];
        }

        
        [shapeLayer setPath:path];
        
        [shapeLayer setStrokeColor:[XYSkinManager instance].xyBubbleViewMessageSendButtonColor.CGColor];
        [shapeLayer setAnchorPoint:CGPointMake(0, 0)];
        shapeLayer.lineWidth = 0.5f;
        [_backgroundImageView.layer addSublayer:shapeLayer];
    }
}

@end
