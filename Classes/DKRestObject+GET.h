//
//  DKRestObject+GET.h
//  DKRest
//
//  Created by Keith Pitt on 23/08/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject.h"

#import "DKRestObject+HTTP.h"

@interface DKRestObject (GET)

+ (void)get:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate;

- (void)get:(NSString *)path parameters:(NSDictionary *)params finish:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate;

@end