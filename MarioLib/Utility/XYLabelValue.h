//
//  XYLabelValue.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents a label value pair
 */
@interface XYLabelValue : NSObject <NSCopying>
{
    NSString* _label;
    NSString* _value;
    id _object;
}

/**
 Label string
 */
@property (nonatomic,strong) NSString* label;

/**
 Value string
 */
@property (nonatomic,strong) NSString* value;

/**
 Any object related to label value field
 This object doesn't involved in isEqual and hash method
 */
@property (nonatomic,strong) id object;

/**
 Static method to create a XYLabelValue object
 */
+(XYLabelValue*)labelWith:(NSString*)l value:(NSString*) v;
@end
