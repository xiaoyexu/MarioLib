//
//  XYTableCell.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYField.h"
//#import <SAPUIColorExtension.h>

/**
 This class represents a single table cell
 */
@interface XYTableCell : NSObject
{
@protected
    UIView* _view;
    XYField* _field;
    NSString* _name;
    XYTableCell* _superCell;
    NSString* _text;
    NSString* _detailText;
    UIColor* _backgroundColor;
    NSInteger _height;
    NSString* _cellIdentifier;
    BOOL _editable;
}
/**
 Define name of cell
 */
@property (nonatomic, strong) NSString* name;

/**
 Define type of cell
 */
@property (nonatomic, strong) NSString* type;

/**
 Any object.
 Reservered for future usage.
 */
@property (nonatomic,strong) id object;

/**
 Define it's super cell, to maintain cascade relationship
 */
@property (nonatomic, strong) XYTableCell* superCell;

/**
 Define field in it
 */
@property (nonatomic,readonly) XYField* field;

/**
 Define view if no field given
 If field is given, the view will be the field.view
 */
@property (nonatomic,readonly) UIView* view;

/**
 Define cell identifier
 */
@property (nonatomic,strong) NSString* cellIdentifier;

/**
 Customizing for method cell for row
 */
@property (nonatomic) BOOL customizedCellForRow;

/**
 Field for UITableViewCell mapping
 */
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* detailText;
@property (nonatomic, strong) NSAttributedString* attributedText;
@property (nonatomic, strong) NSAttributedString* attributedDetailText;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic) BOOL viewAsBackgroundView;
@property (nonatomic) NSInteger height;
@property (nonatomic) BOOL selectable;
@property (nonatomic) BOOL autoDeselected;
@property (nonatomic) UITableViewCellSelectionStyle selectionStyle;
/**
 Only visible field will be counted & displayed in tableview
 */
@property (nonatomic) BOOL visible;

/**
 Editable
 */
@property (nonatomic) BOOL editable;

/**
 Style of default cell, only used when view or field not provided
 */
@property (nonatomic) UITableViewCellStyle style;

/**
 Editing style
 */
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

/**
 Movable
 */
@property (nonatomic) BOOL movable;

/**
 Accessory type
 */
@property (nonatomic) UITableViewCellAccessoryType accessoryType;

-(id)init;
-(id)initWithView:(UIView*)view;
-(id)initWithXYField:(XYField*)field;
+(id)cellWithName:(NSString*)name view:(UIView*)view;
+(id)cellWithName:(NSString*)name xyField:(XYField*)field;
-(void)renderCell;
-(void)setView:(UIView *)view;
-(void)setXYField:(XYField*)field;
-(void)resignFirstResponder;

@end

