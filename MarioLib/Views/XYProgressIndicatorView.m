//
//  XYProgressIndicatorView.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 5/27/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import "XYProgressIndicatorView.h"

@implementation XYProgressIndicatorView
{
    UIView* progressBar;
    CAGradientLayer* gradient;
    UILabel* frontLabel;
    UILabel* backendLabel;
}
@synthesize progress = _progress;
@synthesize color = _color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.backgroundColor = [UIColor whiteColor];
        
        CGSize s = CGSizeMake(2, 2);
        progressBar = [[UIView alloc] initWithFrame:CGRectMake(s.width, s.height, 0, self.bounds.size.height - 2*s.height)];
        progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Front label, not covered by progress bar
        frontLabel = [[UILabel alloc] initWithFrame:self.bounds];
        frontLabel.font = [UIFont systemFontOfSize:16];
        frontLabel.textColor = [UIColor darkGrayColor];
        frontLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:frontLabel];
        [self addSubview:progressBar];
        
        CGRect f = [progressBar convertRect:self.bounds fromView:self];
        
        // Backend label, once covered by progress bar
        backendLabel = [[UILabel alloc] initWithFrame:f];
        backendLabel.font = [UIFont systemFontOfSize:16];
        backendLabel.textColor = [UIColor whiteColor];
        backendLabel.textAlignment = NSTextAlignmentCenter;
        progressBar.clipsToBounds = YES;
        [progressBar addSubview:backendLabel];
        
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGSize s = CGSizeMake(2, 2);
    progressBar.frame = CGRectMake(s.width, s.height, 0, self.bounds.size.height - 2*s.height);
    frontLabel.frame = self.bounds;
    CGRect f = [progressBar convertRect:self.bounds fromView:self];
    backendLabel.frame = f;
}

-(void)setProgress:(float)progress{
    _progress = progress > 1 ? 1.0 : progress;
    frontLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_progress*100)];
    backendLabel.text = frontLabel.text;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect f = progressBar.frame;
    f.size.width = (self.bounds.size.width - 2*2)*_progress;
    progressBar.frame = f;
    [gradient removeFromSuperlayer];
    switch (_color) {
        case XYProgressIndicatorColorRed:{
            gradient = [XYUtility redGradientLayer];
        }
            break;
        case XYProgressIndicatorColorGreen:{
            gradient = [XYUtility greenGradientLayer];
        }
            break;
        case XYProgressIndicatorColorBlue:{
            gradient = [XYUtility blueGradientLayer];
        }
            break;
        case XYProgressIndicatorColorOrange:{
            gradient = [XYUtility orangeGradientLayer];
        }
        default:
            break;
    }
    
    gradient.frame = progressBar.bounds;
    [progressBar.layer insertSublayer:gradient atIndex:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
