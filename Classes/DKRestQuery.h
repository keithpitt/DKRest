//
//  DKRestQuery.h
//  DiscoKit
//
//  Created by Keith Pitt on 29/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "ASIDownloadCache.h"

#import "DKPredicateBuilder.h"
#import "DKAPIRequest.h"
#import "DKRestCacheStrategy.h"

@interface DKRestQuery : DKPredicateBuilder

@property (nonatomic, assign) BOOL search;
@property (nonatomic, assign) Class restClass;
@property (nonatomic, assign) NSURL * queryURL;
@property (nonatomic, assign) DKQueryFinishBlock finishBlock;
@property (nonatomic, readonly) ASIDownloadCache * downloadCache;

@property (nonatomic, copy) NSDate * lastPerformDate;

- (id)initWithClass:(Class)klass url:(NSURL *)url;

- (void)perform:(DKQueryFinishBlock)block;
- (void)perform:(DKQueryFinishBlock)block cacheStrategy:(DKRestCacheStrategy)cache;
- (void)perform:(DKQueryFinishBlock)block cacheStrategy:(DKRestCacheStrategy)cache delegate:(id)delegate;

- (NSString *)compoundPredicateKey;

@end