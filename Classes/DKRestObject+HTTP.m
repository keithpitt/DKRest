//
//  DKRestObject+HTTP.m
//  DKRest
//
//  Created by Keith Pitt on 23/08/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject+HTTP.h"

@implementation DKRestObject (HTTP)

+ (void)startRequestWithObject:(id)object path:(NSString *)path requestMethod:(NSString *)requestMethod parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {
    
    DKAPIRequest * request = [object requestWithPath:path requestMethod:requestMethod];
    request.parameters = params;
    request.finishBlock = finishBlock;
    request.delegate = delegate;
    
    [request startAsynchronous];

}

@end