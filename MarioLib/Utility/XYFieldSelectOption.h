//
//  XYFieldSelectOption.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYSelectOption.h"

/**
 This class represents a single field selection options
 E.g.
 Name     I   EQ  Tom
          I   EQ  Jerry
          ...
 Or
 Birthday  I   EQ  2000.1.1
           I   BT  2002.2.2   2004.4.4
           I   LE  1990.1.1
           ...
 */
@interface XYFieldSelectOption : NSObject <NSCoding>
{
    NSMutableSet* _selectOptions;
}
/**
 Field name
 */
@property (nonatomic,strong) NSString* property;

/**
 NSSet of XYSelectOption object
 */
@property (nonatomic,strong) NSSet* selectOptions;

/**
 Initialization method
 */
-(id)init;

/**
 Initialization method with property and initial selection
 */
-(id)initWithProperty:(NSString*) property andSelectOption:(XYSelectOption*)option;

/**
 Initialization method with property and initial sign, option, low value, high value
 */
-(id)initWithProperty:(NSString*) property andSelectOptionSign:(NSString*)sign option:(NSString*) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue;

/**
 Initialization method with property and selection set
 The set should contain XYSelectOption instance
 */
-(id)initWithProperty:(NSString*) property andSelectOptionSet:(NSSet*)options;

/**
 Add selection object
 @param so Selection option to add
 */
-(void)addSelectOption:(XYSelectOption*)so;

/**
 Set single selection object
 @param so Selection option to set
 */
-(void)setSingleSelectOption:(XYSelectOption*)so;

/**
 Remove selection object
 @param so Selection option to remove
 */
-(void)removeSelectOption:(XYSelectOption*)so;

/**
 Remove all selection object
 */
-(void)clearSelectOption;
@end
