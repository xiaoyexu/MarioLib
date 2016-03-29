//
//  MessageItem.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/5/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XYUIDesign/XYUIDesign.h>

@interface ItemRequest : XYRequest
@property (nonatomic) NSString* itemId;
@end

@interface ItemResponse : XYResponse
@property (nonatomic) NSString* itemId;
@property (nonatomic) NSString* property1;
@property (nonatomic) NSString* property2;
@property (nonatomic) NSString* property3;
@end

@interface ItemMessageAgent : XYMessageAgent

@end
