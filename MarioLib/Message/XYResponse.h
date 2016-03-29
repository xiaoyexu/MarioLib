//
//  XYResponse.h
//  XYUIDesign
//
//  Created by AGS XY on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents a message response
 */
@interface XYResponse : NSObject
@property (nonatomic) NSUInteger responseCode;
@property (nonatomic) NSString* responseDesc;
@end

@interface XYDictResponse : XYResponse
@property (nonatomic,strong) NSString* name;
-(id)initWithJSONData:(NSData*)jsonData;
-(void)setValue:(id)value forKey:(NSString *)key;
-(id)valueForKey:(NSString *)key;
-(void)setJSONData:(NSData*)jsonData;
@end

//address = "";
//birth = "";
//cityId = 0;
//cityName = "";
//districtId = "";
//districtName = "";
//headImg = "http://test.gift.zhizhiwangluo.net/pic/Image/member/11_20150112184927069.jpg";
//memberId = 11;
//nickName = "\U6653\U6654";
//provinceId = 0;
//provinceName = "";
//returnCode = 0;
//returnDesc = "\U64cd\U4f5c\U6210\U529f";
//sign = "\U68a6\U60f3\U603b\U4f1a\U5b9e\U73b0\U7684";
@interface XYLoginResponse : XYResponse
@property (nonatomic) NSString* nickName;
@end