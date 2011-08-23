//
//  DKRestObject+POST.m
//  DKRest
//
//  Created by Keith Pitt on 23/08/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject+POST.h"

@implementation DKRestObject (POST)

+ (void)post:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {
    
    [DKRestObject startRequestWithObject:[self class]
                                    path:path
                           requestMethod:HTTP_POST_VERB
                              parameters:params
                                  finish:finishBlock
                                delegate:delegate];
    
}

- (void)post:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {

    [DKRestObject startRequestWithObject:self
                                    path:path
                           requestMethod:HTTP_POST_VERB
                              parameters:params
                                  finish:finishBlock
                                delegate:delegate];

}

@end