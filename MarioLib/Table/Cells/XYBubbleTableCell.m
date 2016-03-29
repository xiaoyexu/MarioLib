//
//  XYBubbleTableCell.m
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/16/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYBubbleTableCell.h"

//#define SHOW_CELL_COLOR

#define BUBBLE_WIDTH 650

@implementation XYBubbleTableCell
@synthesize timestamp = _timestamp;
@synthesize fromself = _fromself;
@synthesize textView = _textView;
@synthesize paddingWidthLeft = _paddingWidthLeft;
@synthesize paddingWidthRight = _paddingWidthRight;
@synthesize subTextAlignment = _subTextAlignment;
@synthesize subText = _subText;
@synthesize bubbleStyle = _bubbleStyle;

-(id)init{
    if (self = [super init]) {
        _paddingWidthLeft = 15;
        _paddingWidthRight = 15;
    }
    return self;
}

-(id)initWithView:(UIView*)view{
    if (self = [super init]) {
        _view = view;
        _paddingWidthLeft = 15;
        _paddingWidthRight = 15;
    }
    return self;
}

-(id)initWithXYField:(XYField*)field{
    if (self = [super init]) {
        _field = field;
        field != nil && (_view = field.view);
        _paddingWidthLeft = 15;
        _paddingWidthRight = 15;
    }
    return self;
}

-(void)renderCell{
    [super renderCell];
    _name = @"_defaultBubbleCell";
    self.visible = YES;
}

-(void)updateCellView{
    // Create bubble field
    XYBubbleView* tvc = [[XYBubbleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];;
    tvc.bubbleStyle = _bubbleStyle;
    
    // Create bubble cell
    bubbleCell = [[XYDynamicTableCell alloc] initWithView:tvc];
    bubbleCell.showAccessoryButton = NO;
    bubbleCell.selectable = NO;
    
    //[bubbleCell addFooterExtraCell:tableCell];
    
    // Set time
    if (_timestamp != nil) {
        
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bubbleField.view.frame.size.width, 20)];
        headerLabel.text = @"header time";
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
#ifdef SHOW_CELL_COLOR
        headerLabel.backgroundColor = [UIColor greenColor];
#endif
        
        XYBaseView* view = [[XYBaseView alloc] initWithFrame:CGRectMake(0, 0, bubbleField.view.frame.size.width, 20) contentInset:UIEdgeInsetsMake(1, 1, 1, 1)];
        
        [view.viewAtCenter addSubview:headerLabel];
        
        headerCell = [[XYTableCell alloc] initWithView:view];
        headerCell.name = @"headerTime";
        
        char buffer[22]; // Sep 22, 2012 12:15 PM -- 21 chars + 1 for NUL terminator \0
        time_t time = [_timestamp timeIntervalSince1970];
        strftime(buffer, 22, "%b %-e, %Y %-l:%M %p", localtime(&time));
        
        headerLabel.text = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
        headerLabel.textColor = [UIColor grayColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:13];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerCell.visible = YES;
        bubbleCell.headerDisplayRowNumber++;
        [bubbleCell addHeaderExtraCell:headerCell];
    } else {
        bubbleCell.headerDisplayRowNumber = 0;
    }
    
    if (![XYUtility isBlank:_subText]) {
        XYBaseView* view = [[XYBaseView alloc] initWithFrame:CGRectMake(0, 0, tvc.frame.size.width, 20) contentInset:UIEdgeInsetsMake(0, 10, 0, 10)];

        _subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,view.viewAtCenter.frame.size.width , 20)];
        
        _subTextLabel.textAlignment = _subTextAlignment;
        _subTextLabel.text = _subText;
        _subTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _subTextLabel.backgroundColor = [UIColor clearColor];
        _subTextLabel.textColor = [UIColor grayColor];
        _subTextLabel.font = [UIFont boldSystemFontOfSize:14];
        [view.viewAtCenter addSubview:_subTextLabel];
        subTextCell = [[XYTableCell alloc] initWithView:view];
        bubbleCell.headerDisplayRowNumber++;
        [bubbleCell addHeaderExtraCell:subTextCell];
    }
    
    tvc.textView.text = _text;
    [tvc.textView sizeToFit];
    CGRect f = tvc.frame;
    f.size.height = tvc.textView.frame.size.height;
    tvc.frame = f;
  
    tvc.paddingLeft = _paddingWidthLeft;
    tvc.paddingRight = _paddingWidthRight;
    
    
    
    // Set bubble location
   
    CGRect bubbleRect = CGRectZero;
    
    bubbleRect.origin = tvc.textView.frame.origin;
    bubbleRect.size = tvc.textView.frame.size;
    
    bubbleRect.origin.y += 2;
    
    tvc.fromself = _fromself;
    
    if (_fromself) {
        
        tvc.textViewAligment = NSTextAlignmentRight;
        
        switch (_bubbleStyle) {
            case XYBubbleCellStyleDefault:{
                bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MessageBubbleBlue" ofType:@"png"]];
                bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
                bubbleRect.origin.x -= 4;
                bubbleRect.size.width += 12;
            }
                
                break;
            case XYBubbleCellStyleUI5:{
                bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
                //bubbleImageView.backgroundColor = [UIColor whiteColor];
//                bubbleImageView.layer.cornerRadius = 8;
//                bubbleImageView.layer.borderWidth = 0.5;
//                bubbleImageView.layer.borderColor = [XYSkinManager instance].xyBubbleViewMessageSendButtonColor.CGColor;
                bubbleRect.origin.x -= 4;
                bubbleRect.size.height -= 4;
                bubbleRect.size.width += 12;
            }
                break;
            default:
                break;
        }
    
    } else {
        
        tvc.textViewAligment = NSTextAlignmentLeft;
        
        switch (_bubbleStyle) {
            case XYBubbleCellStyleDefault:{
                bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MessageBubbleGray" ofType:@"png"]];
                bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
                bubbleRect.origin.x -= 10;
                bubbleRect.size.width += 14;
            }
                
                break;
            case XYBubbleCellStyleUI5:{
                bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
//                bubbleImageView.backgroundColor = [UIColor whiteColor];
//                bubbleImageView.layer.cornerRadius = 8;
//                bubbleImageView.layer.borderWidth = 0.5;
//                bubbleImageView.layer.borderColor = [XYSkinManager instance].xyBubbleViewMessageSendButtonColor.CGColor;
                bubbleRect.origin.x -= 10;
                bubbleRect.size.height -= 4;
                bubbleRect.size.width += 14;
            }
                break;
            default:
                break;
        }
        
      
    }
    tvc.textView.backgroundColor = [UIColor clearColor];
    bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    bubbleImageView.frame = bubbleRect;
    
//    bubbleImageView = [XYUtility renderBubbleView:bubbleImageView fromself:NO];
    
    tvc.textView.clipsToBounds = NO;
    tvc.backgroundImageView = bubbleImageView;
    //[tvc.textView insertSubview:bubbleImageView atIndex:0];
    
}

-(XYDynamicTableCell*)dynamicTableCellPresentation{
    if (bubbleCell == nil) {
        [self updateCellView];
    }
    return bubbleCell;
}

-(void)resignFirstResponder{
    if (_textView != nil) {
        [_textView resignFirstResponder];
    }
}

@end
