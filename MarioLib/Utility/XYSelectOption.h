//
//  XYSelectOption.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents a selection which has sign, option, low value and high value
 */
@interface XYSelectOption : NSObject <NSCoding>

/**
 Sign field. E.g. I or E
 */
@property (nonatomic,strong) NSString* sign;

/**
 Option field. E.g BT or EQ
 */
@property (nonatomic,strong) NSString* option;

/**
 Low value
 */
@property (nonatomic,strong) NSString* lowValue;

/**
 High value
 */
@property (nonatomic,strong) NSString* highValue;

/**
 Initialization method with sign,option,low value and high value
 @param sign Sign to set
 @param option Option to set
 @param lowValue Low value to set
 @param highValue High value to set
 */
-(id)initWithSign:(NSString*)sign option:(NSString*) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue;

/**
 isEqual method is overriden in order to compare 2 selection
 XYSelectOption object is equal only when sign,option,low value and high value are all eqal
 */
-(BOOL)isEqual:(id)object;

/**
 hash method is overriden in order to compare 2 XYSelectOption objects
 */
-(NSUInteger)hash;
@end
