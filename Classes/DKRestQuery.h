//
//  DKRestQuery.h
//  DiscoKit
//
//  Created by Keith Pitt on 29/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKPredicateBuilder.h"
#import "DKAPIRequest.h"
#import "ASIDownloadCache.h"

@interface DKRestQuery : DKPredicateBuilder

@property (nonatomic, assign) BOOL search;
@property (nonatomic, assign) Class restClass;
@property (nonatomic, assign) DKQueryPerformSuccess successBlock;
@property (nonatomic, assign) DKQueryPerformError errorBlock;
@property (nonatomic, readonly) ASIDownloadCache * downloadCache;

- (id)initWithClass:(Class)klass;

- (void)perform:(DKQueryPerformSuccess)success error:(DKQueryPerformError)error;
- (void)perform:(DKQueryPerformSuccess)success error:(DKQueryPerformError)error cache:(BOOL)cache;
- (void)perform:(DKQueryPerformSuccess)success error:(DKQueryPerformError)error cache:(BOOL)cache uploadDelegate:(id)uploadDelegate downloadDelegate:(id)downloadDelegate;

@end