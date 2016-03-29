//
//  XYRequest.h
//  XYUIDesign
//
//  Created by AGS XY on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDesighHeader.h"

/**
 This class represents a message request
 */
@interface XYRequest : NSObject

@end

@interface XYDictRequest : XYRequest
@property (nonatomic,strong) NSString* name;
-(void)setValue:(id)value forKey:(NSString *)key;
-(id)valueForKey:(NSString *)key;
@end


/**
 Application level base request
 */
@interface XYAppRequest : XYRequest
@property(nonatomic) NSUInteger memberId;
@property(nonatomic, strong) NSString* uniqueGlobalDeviceIdentifier;
@property(nonatomic, strong) NSString* deviceString;
@end

/**
 Application level message
 */
@interface XYLoginRequest : XYAppRequest
@property(nonatomic, strong) NSString* mobile;
@property(nonatomic, strong) NSString* password;
@end