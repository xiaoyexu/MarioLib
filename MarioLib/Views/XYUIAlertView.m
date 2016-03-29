//
//  XYUIAlertView.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 5/15/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUIAlertView.h"

#define RGBA(r,g,b,a)       [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:(a)]
#define FONT                @"HelveticaNeue-Bold"

typedef enum {
    red,
    blue,
    green,
    alpha,
}colorComponent;

typedef enum {
    GRAlertViewStyleNone,
    GRAlertStyleAlert,
    GRAlertStyleSuccess,
    GRAlertStyleWarning,
    GRAlertStyleInfo,
} GRAlertViewStyle;

typedef enum {
    GRAlertAnimationNone,
    GRAlertAnimationLines,
    GRAlertAnimationBorder,
} GRAlertAnimation;

@implementation XYUIAlertView
{
    GRAlertViewStyle _style;
    GRAlertAnimation _animation;
    
    UIColor* _bottomColor;
    UIColor* _middleColor;
    UIColor* _topColor;
    UIColor* _lineColor;
    NSString* _fontName;
    UIColor* _fontColor;
    UIColor* _fontShadowColor;
    NSString* _imageName;
}
@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundImage = _backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)layoutSubviews{
    [self setTopColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
          middleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
          bottomColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
            lineColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    // Change the default alert view background color
    if (self.backgroundColor == nil) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        //self.backgroundColor = [UIColor SAPBlueButtonColor];
    }
    
    // Change alert view layout
    if (self.backgroundImage != nil || self.backgroundColor != nil) {
        int labelLayer = 0;
        int imageViewLayer = 0;
        for (UIView* view in self.subviews) {
            // Change UIImageView look & feel
            if ([view class] == [UIImageView class] && imageViewLayer == 0) {
                view.backgroundColor = self.backgroundColor;
                ((UIImageView*)view).hidden = YES;
                imageViewLayer++;
            } else {
                ((UIImageView*)view).layer.cornerRadius = 10;
            }
            // Change UILabel look & feel
            if ([view class] == [UILabel class]) {
                if (labelLayer == 0) {
                    // The first UILabel is title
                    ((UILabel*)view).textColor = [UIColor orangeColor];//[UIColor SAPGoldenButtonColor];
                } else {
                    // Others are message content
                    ((UILabel*)view).textColor = [UIColor whiteColor];
                }
                labelLayer++;
            }
            // Change UIButton look & feel
            if ([view isKindOfClass:[UIButton class]]) {
                [((UIButton*)view) setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [((UIButton*)view) setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
            }
        }
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //if (!_style && !_topColor) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect activeBounds = self.bounds;
    CGFloat cornerRadius = 10.0f;
    CGFloat inset = 5.5f;
    CGFloat originX = activeBounds.origin.x + inset;
    CGFloat originY = activeBounds.origin.y + inset;
    CGFloat width = activeBounds.size.width - inset * 2.0f;
    CGFloat height = activeBounds.size.height - (inset + 2.0) * 2.0f;
    
    CGRect bPathFrame = CGRectMake(originX, originY, width, height - (self.numberOfButtons?0:50));
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:bPathFrame cornerRadius:cornerRadius].CGPath;
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 6.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    // Gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t count = 3;
    CGFloat locations[3] = {0.0f, 0.57f, 1.0f};
    CGFloat components[12] =
    {	getColor(_topColor, red), getColor(_topColor, green), getColor(_topColor, blue), getColor(_topColor, alpha),
        getColor(_middleColor, red), getColor(_middleColor, green), getColor(_middleColor, blue), getColor(_middleColor, alpha),
        getColor(_bottomColor, red), getColor(_bottomColor, green), getColor(_bottomColor, blue), getColor(_bottomColor, alpha)};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    
    CGPoint startPoint = CGPointMake(activeBounds.size.width * 0.5f, 0.0f);
    CGPoint endPoint = CGPointMake(activeBounds.size.width * 0.5f, activeBounds.size.height);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    switch (_animation) {
        case GRAlertAnimationLines:
            
            moveFactor = moveFactor > 28.0f ? 0.0f : --moveFactor;
            
            CGContextSaveGState(context);
            CGRect hatchFrame = CGRectMake(0.0f, 0.0f, activeBounds.size.width, (activeBounds.size.height));
            CGContextClipToRect(context, hatchFrame);
            
            CGMutablePathRef hatchPath = CGPathCreateMutable();
            int lines = (hatchFrame.size.width/60.0f + hatchFrame.size.height);
            for(int i = -1; i < lines; i++) {
                CGPathMoveToPoint(hatchPath, NULL, 60.0f * i + moveFactor, 0.0f);
                CGPathAddLineToPoint(hatchPath, NULL, 1.0f, 60.0f * i + moveFactor);
            }
            CGContextAddPath(context, hatchPath);
            CGPathRelease(hatchPath);
            CGContextSetLineWidth(context, 20.0f);
            CGContextSetLineCap(context, kCGLineCapSquare);
            CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
            CGContextDrawPath(context, kCGPathStroke);
            CGContextRestoreGState(context);
            break;
            
        default:
            break;
    }
    
    // Clip the gloss clipping path to the rounded rectangle
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(activeBounds) + cornerRadius + 0.5, CGRectGetMinY(activeBounds) + 0.5);
    CGContextAddArc(context, CGRectGetMaxX(activeBounds) - cornerRadius + 0.5, CGRectGetMinY(activeBounds) + cornerRadius + 0.5, cornerRadius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(activeBounds) - cornerRadius + 0.5, CGRectGetMaxY(activeBounds) - cornerRadius + 0.5, cornerRadius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(activeBounds) + cornerRadius + 0.5, CGRectGetMaxY(activeBounds) - cornerRadius + 0.5, cornerRadius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(activeBounds) + cornerRadius + 0.5, CGRectGetMinY(activeBounds) + cornerRadius + 0.5, cornerRadius, M_PI, 3 * M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Set up a clipping path for the gloss gradient
    CGFloat glossRadius = 1100.0f;
    CGPoint glossCenterPoint = CGPointMake(CGRectGetMidX(activeBounds), 35.0 - glossRadius);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, glossCenterPoint.x, glossCenterPoint.y);
    CGContextAddArc(context, glossCenterPoint.x, glossCenterPoint.y, glossRadius, 0.0, M_PI, 0
                    );
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the gloss gradient
    CGGradientRef glossGradient;
    CGFloat locations2[2] = { 0.0, 1.0 };
    CGFloat components2[8] = { 1.0, 1.0, 1.0, 0.65,
        1.0, 1.0, 1.0, 0.06 };
    glossGradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), components2, locations2, 2);
    CGPoint topCenter = CGPointMake(CGRectGetMidX(activeBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(activeBounds), 35.0f);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
    CGGradientRelease(glossGradient);
    
    CGContextRestoreGState(context);
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, _animation==GRAlertAnimationBorder?4.0f:2.0f);
    CGContextSetStrokeColorWithColor(context, _fontColor?_fontColor.CGColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
    
    if (_animation == GRAlertAnimationBorder) {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        
        shapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(activeBounds), CGRectGetHeight(activeBounds));
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = _lineColor.CGColor;
        shapeLayer.lineWidth = 4.0f;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:10], nil];
        shapeLayer.path = path;
    }
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)setTopColor:(UIColor*)tc middleColor:(UIColor*)mc bottomColor:(UIColor*)bc lineColor:(UIColor*)lc {
    _topColor = tc;
    _middleColor = mc;
    _bottomColor = bc;
    _lineColor = lc;
}

- (void)setFontName:(NSString*)fn fontColor:(UIColor*)fc fontShadowColor:(UIColor*)fsc {
    _fontName = fn;
    _fontColor = fc;
    _fontShadowColor = fsc;
}

- (void)setImage:(NSString *)imageName {
    _imageName = imageName;
}

float getColor(UIColor *color, colorComponent comp) {
    CGFloat redColor = 0.0, greenColor = 0.0, blueColor = 0.0, alphaValue = 0.0;
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&redColor green:&greenColor blue:&blueColor alpha:&alphaValue];
        switch (comp) {
            case red:
                return redColor;
                break;
            case green:
                return greenColor;
                break;
            case blue:
                return blueColor;
                break;
            case alpha:
                return alphaValue;
                break;
        }
    }
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return components[comp];
}


@end
