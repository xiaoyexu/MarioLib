//
//  XYBubbleTableCell.h
//  XYUIDesign
//
//  Created by Xu Xiaoye on 4/16/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableCell.h"
#import "XYDynamicTableCell.h"
#import "XYInputTextViewField.h"
#import "XYUtility.h"
#import "XYBubbleView.h"

/**
 This class represents a bubble cell
 */
@interface XYBubbleTableCell : XYTableCell
{
    @protected
    UILabel* headerLabel;
    XYTableCell* headerCell;
    
    UILabel* _subTextLabel;
    XYTableCell* subTextCell;
    
    XYInputTextViewField* bubbleField;
    
    // Use XYDynamicTableCell for each reply
    XYDynamicTableCell* bubbleCell;
    UIImageView* bubbleImageView;
    UILabel* bubbleText;
    UIImage* bubble;
}

/**
 Time of message
 */
@property (nonatomic, strong) NSDate* timestamp;

// Text of message use property text from super class

/**
 If YES, show at right side, otherwise at left side
 */
@property (nonatomic) BOOL fromself;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic) CGFloat paddingWidthLeft;
@property (nonatomic) CGFloat paddingWidthRight;
@property (nonatomic) NSString* subText;
@property (nonatomic) NSTextAlignment subTextAlignment;
@property (nonatomic) XYBubbleCellStyle bubbleStyle;


-(id)init;

/**
 Initialization method with field, no use!!!
 Notice:pass field or view won't work for Bubble table cell
 */
-(id)initWithXYField:(XYField *)field;
-(id)initWithView:(UIView *)view;

/**
 @return XYDynamicTableCell for rendering
 */
-(XYDynamicTableCell*)dynamicTableCellPresentation;

@end

