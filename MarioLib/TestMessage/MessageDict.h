//
//  MessageDict.h
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/6/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XYUIDesign/XYUIDesign.h>

@interface StoryListItem : NSObject
@property (nonatomic,strong) NSNumber* storyId;
@property (nonatomic,strong) NSString* header;
@property (nonatomic,strong) NSString* item;
@end

@interface XYGetFullStoryRequest : XYDictRequest
@property (nonatomic,strong) NSNumber* storyId;
@end

@interface XYGetFullStoryResponse : XYDictResponse
@property (nonatomic,strong) NSArray* stories;
@end

@interface XYGetFullStoryMessageAgent : XYDictMessageAgent

@end
