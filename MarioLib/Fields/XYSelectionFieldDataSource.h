//
//  XYSelectionFieldDataSource.h
//  XYUIDesignTest
//
//  Created by Xu, Xiaoye on 2/25/14.
//  Copyright (c) 2014 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYSelectionField.h"
@class XYSelectionField;

@protocol XYSelectionFieldDataSource <NSObject>
@required
-(NSArray*)dataSourceOfXYSelectionField:(XYSelectionField*)field;
@end
