//
//  DKRestObject+GET.m
//  DKRest
//
//  Created by Keith Pitt on 23/08/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject+GET.h"

@implementation DKRestObject (GET)

+ (void)get:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {
    
    [DKRestObject startRequestWithObject:[self class]
                                    path:path
                           requestMethod:HTTP_GET_VERB
                              parameters:params
                                  finish:finishBlock
                                delegate:delegate];
    
}

- (void)get:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {

    [DKRestObject startRequestWithObject:self
                                    path:path
                           requestMethod:HTTP_GET_VERB
                              parameters:params
                                  finish:finishBlock
                                delegate:delegate];

}

@end