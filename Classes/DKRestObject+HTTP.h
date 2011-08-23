//
//  DKRestObject+HTTP.h
//  DKRest
//
//  Created by Keith Pitt on 23/08/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject.h"

@interface DKRestObject (HTTP)

+ (void)startRequestWithObject:(id)object path:(NSString *)path requestMethod:(NSString *)requestMethod parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate;

@end