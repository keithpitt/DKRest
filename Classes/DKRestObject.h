//
//  DKRestObject.h
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DKAPIRequest.h"

#import "DKRestRouterProtocol.h"
#import "DKRestObjectProtocol.h"
#import "DKRestQuery.h"

@interface DKRestObject : NSObject <DKRestObjectProtocol>

+ (id<DKRestRouterProtocol>)router;

+ (DKRestQuery *)query;

+ (DKRestQuery *)search;

+ (DKRestQuery *)searchWithPath:(NSString *)path;

+ (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod;

- (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod;

- (void)setId:(id)identifier;

- (BOOL)isPersisted;

- (void)beforeCreate;

- (void)beforeUpdate;

- (void)beforeSave;

- (void)afterCreate:(DKAPIResponse *)response;

- (void)afterUpdate:(DKAPIResponse *)response;

- (void)afterSave:(DKAPIResponse *)response;

- (NSDictionary *)attributesToPost;

- (NSDictionary *)attributes;

- (void)setAttributes:(NSDictionary *)attributes;

- (DKAPIRequest *)save:(DKAPIRequestFinishBlock)finishBlock;

- (DKAPIRequest *)save:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate;

@end