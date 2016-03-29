//
//  MessageDict.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 2/6/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "MessageDict.h"

@implementation StoryListItem
@synthesize storyId;
@synthesize header;
@synthesize item;
@end

@implementation XYGetFullStoryRequest
@synthesize storyId;
@end

@implementation XYGetFullStoryResponse
@synthesize stories;
@end

@implementation XYGetFullStoryMessageAgent

-(void)normalize:(XYRequest *)request to:(XYHTTPRequestObject *)requestObj{
    [super normalize:request to:requestObj];
    NSLog(@"%@",requestObj.body);
}

-(void)deNormalize:(XYHTTPResponseObject *)responseObj to:(XYResponse *__autoreleasing *)response{
    
    XYGetFullStoryResponse* itemResponse = [XYGetFullStoryResponse new];

    [super deNormalize:responseObj to:&itemResponse];
    
    NSArray* array = [itemResponse valueForKey:@"collection"];
    
    NSMutableArray* resultArray = [NSMutableArray new];
    for (NSDictionary* d in array) {
        NSLog(@"%@",d);
        
        StoryListItem* sli = [StoryListItem new];
        sli.storyId = [d objectForKey:@"id"];
        sli.header = [d objectForKey:@"header"];
        sli.item = [d objectForKey:@"item"];
        [resultArray addObject:sli];
    }
    itemResponse.stories = resultArray;
    
    *response = itemResponse;
}

-(XYResponse*)demoResponse{
    XYGetFullStoryResponse* response = [XYGetFullStoryResponse new];
    
    return response;
}

@end
