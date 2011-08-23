//
//  DKRestObject+PUT.m
//  DKRest
//
//  Created by Keith Pitt on 23/08/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject+PUT.h"

@implementation DKRestObject (PUT)

+ (void)put:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {
    
    [DKRestObject startRequestWithObject:[self class]
                                    path:path
                           requestMethod:HTTP_PUT_VERB
                              parameters:params
                                  finish:finishBlock
                                delegate:delegate];
    
}

- (void)put:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {

    [DKRestObject startRequestWithObject:self
                                    path:path
                           requestMethod:HTTP_PUT_VERB
                              parameters:params
                                  finish:finishBlock
                                delegate:delegate];

}

@end