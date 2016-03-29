//
//  XYUIAlertView2.m
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 12/19/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUIAlertView2.h"
#import "XYUIAlertView.h"

#define ALERT_MAX_WIDTH 150

@implementation XYUIAlertView2
{
    UIView* alertContentView;
    UILabel* alertTitle;
    UITextView* alertDetailText;
    
    NSMutableArray* buttonTitles;
    NSMutableArray* buttons;
    XYActivityIndicatorIconView* aiv;
    XYProgressIndicatorView* piv;
    id<XYUIAlertViewDelegate> _alertDelegate;
}
@synthesize title = _title;
@synthesize message = _message;
@synthesize alertViewStyle = _alertViewStyle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    if (self = [super init]) {
        _title = title;
        _message = message;
        _alertDelegate = delegate;
        buttonTitles = [NSMutableArray new];
        buttons = [NSMutableArray new];
        
        if (![XYUtility isBlank:cancelButtonTitle]) {
            [self addCancelButtonWithTitle:cancelButtonTitle];
        }
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (![XYUtility isBlank:otherButtonTitles]) {
            [self addButtonWithTitle:otherButtonTitles];
            NSString* otherButtonTitle;
            while((otherButtonTitle = va_arg(args,NSString*))){
                [self addButtonWithTitle:otherButtonTitle];
            }
            
        }
        va_end(args);
        //self.backgroundColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.5];
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

-(void)show{
    UIView* screenView = [XYUtility mainWindowView];
    self.frame = screenView.bounds;
    self.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
        [screenView addSubview:self];
    } completion:^(BOOL finished) {
        
    }];
    
    // Create all subviews
    if (alertContentView == nil) {
        alertContentView = [[UIView alloc] initWithFrame:CGRectZero];
        alertContentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        alertContentView.backgroundColor = [UIColor whiteColor];
        alertContentView.layer.cornerRadius = 5;
        alertContentView.layer.borderColor = [XYUtility sapBlueColor].CGColor;
        alertContentView.layer.borderWidth = 1.0f;
        alertContentView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        alertContentView.layer.shadowOffset = CGSizeMake(0, 0);
        alertContentView.layer.shadowOpacity = 0.8;
        alertContentView.layer.shadowRadius = 30;
        [self addSubview:alertContentView];
    }
    if (alertTitle == nil) {
        alertTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        alertTitle.text = _title;
        alertTitle.font = [UIFont boldSystemFontOfSize:20];
        alertTitle.textAlignment = NSTextAlignmentCenter;
        alertTitle.backgroundColor = [UIColor clearColor];
        [alertContentView addSubview:alertTitle];
    }
    if (alertDetailText == nil) {
        alertDetailText = [[UITextView alloc] initWithFrame:CGRectZero];
        alertDetailText.text = _message;
        alertDetailText.font = [UIFont systemFontOfSize:18];
        alertDetailText.editable = NO;
        alertDetailText.backgroundColor = [UIColor clearColor];
        alertDetailText.scrollEnabled = YES;
        [alertContentView addSubview:alertDetailText];
    }
    if (aiv == nil) {
        aiv = [[XYActivityIndicatorIconView alloc] initWithFrame:CGRectZero];
        [alertContentView addSubview:aiv];
    }
    if (piv == nil) {
        piv = [[XYProgressIndicatorView alloc] initWithFrame:CGRectZero];
        piv.backgroundColor = [UIColor clearColor];
        [alertContentView addSubview:piv];
    }
    [self adjustSubviews];
}

-(void)adjustSubviews{
    UIView* screenView = [XYUtility mainWindowView];
    
    // Adjust frame of each subview
    CGRect alertContentViewFrame = CGRectZero;
    UIEdgeInsets alertContentViewInset = UIEdgeInsetsMake(10, 5, 10, 5);
    alertContentViewFrame.size.height += alertContentViewInset.top;
    
    // Alert title
    CGRect alertTitleFrame = CGRectMake(alertContentViewInset.right, alertContentViewInset.top, 0, 40);
    if (![XYUtility isBlank:_title]) {
        [alertTitle sizeToFit];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            alertTitleFrame.size.width = MAX(alertTitle.bounds.size.width + alertContentViewInset.left + alertContentViewInset.right, ALERT_MAX_WIDTH*2);
        } else {
            alertTitleFrame.size.width = MAX(alertTitle.bounds.size.width + alertContentViewInset.left + alertContentViewInset.right, ALERT_MAX_WIDTH);
        }
    } else {
        alertTitleFrame.size.width = 50;
        alertTitleFrame.size.height = 0;
    }
    alertTitle.frame = alertTitleFrame;
    
    alertContentViewFrame.size.width = alertTitleFrame.size.width + alertContentViewInset.left + alertContentViewInset.right;
    alertContentViewFrame.size.height += alertTitleFrame.size.height;
    
    // Alert detail text
    CGRect alertDetailTextFrame = CGRectMake(alertContentViewInset.right, alertContentViewFrame.size.height + 2, 0, 0);
    
    if (![XYUtility isBlank:_message]) {
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [alertDetailText sizeToFit];
            alertDetailTextFrame.size.width = MAX(alertDetailText.bounds.size.width + alertContentViewInset.left + alertContentViewInset.right, ALERT_MAX_WIDTH*2);
            alertContentViewFrame.size.width = MAX(alertDetailTextFrame.size.width, alertTitleFrame.size.width);
            alertTitleFrame.size.width = alertContentViewFrame.size.width;
            alertTitle.frame = alertTitleFrame;
            alertDetailTextFrame.size.height = MAX(alertDetailText.contentSize.height, alertDetailText.bounds.size.height);
            
        } else {
            CGSize s = [alertDetailText sizeThatFits:CGSizeMake(ALERT_MAX_WIDTH, 400)];
            alertDetailTextFrame.size.width = s.width;
            alertDetailTextFrame.size.height = s.height;
            //alertDetailTextFrame.size.width = MAX(alertDetailText.bounds.size.width + alertContentViewInset.left + alertContentViewInset.right, ALERT_MAX_WIDTH);
            alertDetailTextFrame.size.width = MAX(s.width, alertTitleFrame.size.width);
        }
    }
    
    alertDetailText.frame = alertDetailTextFrame;
    alertContentViewFrame.size.height += alertDetailTextFrame.size.height;
    
    // Indicator
    if (_alertViewStyle  == XYUIAlertViewActivityIndicator) {
        CGRect aivFrame = CGRectMake((alertContentViewFrame.size.width - 25)/2.0, alertContentViewFrame.size.height + 2, 25,25);
        aiv.hidden = NO;
        aiv.frame = aivFrame;
        aiv.backgroundColor = [UIColor clearColor];
        if (!aiv.isAnimating) {
            [aiv startAnimating];
        }
        alertContentViewFrame.size.height += aivFrame.size.height + 2;
    } else if (_alertViewStyle == XYUIAlertViewProgressIndicator) {
        CGRect pivFrame = CGRectMake(alertContentViewInset.right, alertContentViewFrame.size.height + 5, alertContentViewFrame.size.width - alertContentViewInset.right - alertContentViewInset.left, 25);
        piv.frame = pivFrame;
        alertContentViewFrame.size.height += pivFrame.size.height + 5;
    }
    
    // Buttons
    if (buttons.count != 0) {
        alertContentViewFrame.size.height += 5;
    }
    for (NSString* button in buttonTitles) {
        UIButton* b = [buttons objectAtIndex:[buttonTitles indexOfObject:button]];
        alertContentViewFrame.size.height += 5;
        b.frame = CGRectMake(alertContentViewInset.right, alertContentViewFrame.size.height, alertContentViewFrame.size.width - alertContentViewInset.right - alertContentViewInset.left, 40);
        [alertContentView addSubview:b];
        alertContentViewFrame.size.height += 40;
    }
    alertContentViewFrame.size.height += alertContentViewInset.bottom;
    
    //UIView* screenView = [XYUtility mainWindowView];
    alertContentViewFrame.origin.x = (screenView.bounds.size.width - alertContentViewFrame.size.width)/2.0;
    alertContentViewFrame.origin.y = (screenView.bounds.size.height - alertContentViewFrame.size.height)/2.0;
    alertContentView.frame = alertContentViewFrame;
}

-(void)cancelButtonClicked:(UIButton*)sender{
    [self dismiss];
    [_alertDelegate alertView:self clickedButtonAtIndex:sender.tag];
}

-(void)buttonClicked:(UIButton*)sender{
    [self dismiss];
    [_alertDelegate alertView:self clickedButtonAtIndex:sender.tag];
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    [self dismiss];
}

-(void)dismiss{
    self.alpha = 1;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        // Must stop animation
        if (aiv != nil) {
            [aiv stopAnimating];
        }
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)addCancelButtonWithTitle:(NSString *)title{
    if (title == nil) {
        return 0;
    }
    [buttonTitles addObject:title];
    UIButton* b = [[UIButton alloc] initWithFrame:CGRectZero];
    b.tag = [buttonTitles indexOfObject:title];
    [b addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [b setTitle:title forState:UIControlStateNormal];
    // gray [UIColor colorWithRed:66/255.0 green:72/255.0 blue:75/255.0 alpha:1]
    // [UIColor colorWithRed:205/255.0 green:25/255.0 blue:25/255.0 alpha:1]
    b.backgroundColor = [UIColor colorWithRed:205/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    [buttons addObject:b];
    return [buttonTitles indexOfObject:title];
}

- (NSInteger)addButtonWithTitle:(NSString *)title{
    if (title == nil) {
        return 0;
    }
    [buttonTitles addObject:title];
    UIButton* b = [[UIButton alloc] initWithFrame:CGRectZero];
    b.tag = [buttonTitles indexOfObject:title];
    [b addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [b setTitle:title forState:UIControlStateNormal];

    b.backgroundColor = [UIColor colorWithRed:0/255.0 green:120/255.0 blue:51/255.0 alpha:1];;
    [buttons addObject:b];
    return [buttonTitles indexOfObject:title];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex{
    return (NSString*)[buttonTitles objectAtIndex:buttonIndex];
}

-(void)log:(NSString *)status{
    _message = status;
    alertDetailText.text = _message;
    [self adjustSubviews];
}

-(void)progress:(NSNumber *)progress{
    piv.progress = progress.floatValue;
}

-(NSInteger)numberOfButtons{
    return buttons.count;
}

@end
