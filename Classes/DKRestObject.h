//
//  DKRestObject.h
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DKAPIRequest.h"
#import "DKRestConfiguration.h"
#import "DKAPIFormDataProtocol.h"

#import "DKRestQuery.h"

@interface DKRestObject : NSObject <DKAPIFormDataProtocol>

+ (DKRestConfiguration *)resourceConfiguration;
+ (void)configureResource:(DKRestConfiguration *)config;

+ (DKRestQuery *)query;
+ (DKRestQuery *)queryWithPath:(NSString *)path;

+ (DKRestQuery *)search;
+ (DKRestQuery *)searchWithPath:(NSString *)path;

+ (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod;

- (id)initWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)isPersisted;

- (void)beforeCreate;
- (void)beforeUpdate;
- (void)beforeSave;
- (void)afterCreate:(DKAPIResponse *)response;
- (void)afterUpdate:(DKAPIResponse *)response;
- (void)afterSave:(DKAPIResponse *)response;

- (NSDictionary *)attributes;
- (NSDictionary *)attributesWithMappingRules:(NSDictionary *)mappingRules andIgnoreProperties:(NSArray *)ignoreProperties;

- (void)setAttributes:(NSDictionary *)attributes;

- (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod;

- (DKAPIRequest *)save:(DKAPIRequestFinishBlock)finishBlock;
- (DKAPIRequest *)save:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate;

@end

#import "DKRestObject+GET.h"
#import "DKRestObject+POST.h"
#import "DKRestObject+PUT.h"
#import "DKRestObject+DELETE.h"

#import "DKAPIResponse.h"