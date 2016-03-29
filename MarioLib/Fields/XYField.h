//
//  XYField.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYFieldView.h"
#import "XYSkinManager.h"

@class XYTableCell;

/**
 XYField represents an input field, each field has XYBaseView for UI interaction
 The field cannot be added to view directly, but you can add it's view. The instance should be saved within view controller class in order not to be destoryed by gc
 */
@interface XYField : NSObject
{
@protected
    XYBaseView* _view;
    NSString* _name;
    NSString* _value;
    NSInteger _height;
    BOOL _editable;
    XYTableCell* _tableCell;
}

/**
 A SALBaseView object as view container
 */
@property (nonatomic,readonly) XYBaseView* view;

/**
 Name or identifer of field
 */
@property (nonatomic,readonly) NSString* name;

/**
 Value of field
 */
@property (nonatomic,strong) NSString* value;

/**
 Whether field is editable
 */
@property (nonatomic) BOOL editable;

/**
 A reference to SALTableCell if embedded in
 */
@property (nonatomic,strong) XYTableCell* tableCell;

/**
 Initialization method
 */
-(id)init;

/**
 Initialization method with field name
 @param name Name or identifier of field
 */
-(id)initWithName:(NSString*)name;

/**
 Initialization method with field name and frame
 By default SALFieldView is used
 @param name Name or identifier of field
 @param f Frame of SALBaseView
 @param r Ratio of left view and right view
 */
-(id)initWithName:(NSString*)name frame:(CGRect)f ratio:(float) r;

/**
 Clear field value
 */
-(void)clearValue;

/**
 Resign first responder for any view in SALBaseView
 */
-(void)resignFirstResponder;
@end

