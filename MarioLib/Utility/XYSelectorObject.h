//
//  SALSelectorObject.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 SAL. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents a iOS selector
 */
@interface XYSelectorObject :NSObject
{
@protected
    NSValue* _selectorValue;
    id _target;
}

/**
 Object that passed to selector
 */
@property (nonatomic,strong) id object;

/**
 Initialization method with selector and target
 @param selector Normal iOS selector
 @param target Object where selector will be called on
 */
-(id)initWithSEL:(SEL)selector target:(id)target;

/**
 Execute selector
 */
-(void)performSelector;
@end
