//
//  DKRestQuery.m
//  DiscoKit
//
//  Created by Keith Pitt on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DKRestQuery.h"

#import "DKRestObject.h"
#import "DKCoreDataImporter.h"
#import "DKAPIResponse.h"

#import "NSString+Inflections.h"
#import "NSString+Hash.h"

@implementation DKRestQuery

@synthesize restClass, finishBlock, search, downloadCache;

@synthesize lastPerformDate;

- (id)initWithClass:(Class)klass {
    
    if ((self = [super init])) {
        self.restClass = klass;
    }
    
    return self;
    
}

- (NSDictionary *)simplePostData {
    
    NSMutableDictionary * data = [NSMutableDictionary dictionary];
    NSString * param;
    
    for (DKPredicate * predicate in self.predicates) {
        param = [[predicate.info objectForKey:@"column"] underscore];
        [data setValue:[predicate.info objectForKey:@"value"] forKey:param];
    }
    
    return data;
    
}

- (NSDictionary *)metaSearchPostData {
    
    NSMutableDictionary * data = [NSMutableDictionary dictionary];
    NSString * param;
    
    for (DKPredicate * predicate in self.predicates) {
        
        param = [[predicate.info objectForKey:@"column"] underscore];
        
        switch (predicate.predicateType) {
                
            case DKPredicateTypeEquals:
                [data setValue:[predicate.info objectForKey:@"value"]
                        forKey:[NSString stringWithFormat:@"%@_equals", param]];
                break;
                
            default:
                break;
                
        }
        
    }
    
    // We only support 1 sorter at the moment
    
    if ([self.sorters count] > 0) {
        
        NSSortDescriptor * sorter = [self.sorters lastObject];
        
        [data setValue:[NSString stringWithFormat:@"%@.%@", [sorter.key underscore], sorter.ascending ? @"asc" : @"desc"]
                forKey:@"meta_sort"];
        
    }
        
    return [NSDictionary dictionaryWithObject:data forKey:@"search"];
    
}

- (void)importData:(NSArray *)data success:(void (^)(void))success {
    
    [DKCoreDataImporter import:^(DKCoreDataImporter * importer) {
        
        // Import the data
        [importer import:data];
        
    } completion:^{
        
        // If we have a completion block...
        if (success) success();
        
        // Update the last perform time
        self.lastPerformDate = [NSDate date];
        
    } background:YES];
    
}

- (NSArray *)convertToRestResources:(NSArray *)data {
    
    // Create restfull objects based on the data
    NSMutableArray * resources = [NSMutableArray array];
    NSDictionary * attributes;
    
    DKRestObject * object;
    
    for (NSDictionary * dictionary in data) {
        
        // Grab the attributes
        attributes = [dictionary objectForKey:[self.restClass performSelector:@selector(resourceName)]];
        
        // Create a rest resource
        object = [self.restClass new];
        [object setAttributes:attributes];
        
        // Add it to the resources array
        [resources addObject:object];
        
        // Release the object
        [object release];
        
    }
    
    return resources;
    
}

- (void)perform:(DKQueryFinishBlock)block {
    
    return [self perform:block cacheStrategy:DKRestCacheStrategyNone delegate:nil];
    
}

- (void)perform:(DKQueryFinishBlock)block cacheStrategy:(DKRestCacheStrategy)cache {
    
    return [self perform:block cacheStrategy:cache delegate:nil];
    
}

- (void)perform:(DKQueryFinishBlock)block cacheStrategy:(DKRestCacheStrategy)cache delegate:(id)delegate {
    
    [self retain];
    
    // Copy the success block (we should always have one)
    self.finishBlock = Block_copy(block);
    
    // Grab the router for the resource
    id <DKRestRouterProtocol> router = [self.restClass performSelector:@selector(router)];
    
    // Create a new API request
    DKAPIRequest * request = [DKAPIRequest new];
    
    request.delegate = delegate;
    request.requestMethod = HTTP_GET_VERB;
    request.url = [router performSelector:@selector(routeFor:) withObject:restClass];
    
    // Are we caching this response?
    if (cache == DKRestCacheStrategyPersisted || cache == DKRestCacheStrategySession) {
        
        if (cache == DKRestCacheStrategyPersisted)
            request.cacheStrategy = DKAPICacheStrategyPersisted;
        else if (cache == DKRestCacheStrategySession)
            request.cacheStrategy = DKAPICacheStrategySession;
    
        request.downloadCache = downloadCache;
        
    }
    
    // Set the post data.
    if (self.search)
        request.parameters = [self metaSearchPostData];
    else
        request.parameters = [self simplePostData];
    
    request.finishBlock = ^(DKAPIResponse * response, NSError * error) {
      
        if (!error) {
            
            // The response data
            NSArray * data = (NSArray*)response.data;
            
            void (^finished)(void) = ^ {
                
                if (self.finishBlock) {
                
                    // Run the success block with the rest resources
                    NSArray * resources = [self convertToRestResources:data];
                    
                    // Call the success block with the resources
                    self.finishBlock(resources, error);
                    
                }
                
                // Release ourself
                [self release];
                
                // Last sync date
                [self setLastPerformDate:[NSDate date]];
                
            };
            
            if (cache == DKRestCacheStrategyCoreData) {
                
                // Start importing the data
                [self importData:data success:finished];
                
            } else {
                
                // Lets just finish up
                finished();
                
            }
            
        } else {
            
            finishBlock(nil, error);
            
            [self release];
            
        }
        
    };
    
    // Kick off the request
    [request startAsynchronous];
    
    // Release it
    [request release];
    
}

- (ASIDownloadCache *)downloadCache {
    
    if (!downloadCache) {
        NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        downloadCache = [[ASIDownloadCache alloc] init];
        downloadCache.storagePath = [NSString stringWithFormat:@"%@/%@", rootPath, [self compoundPredicateKey]];
    }
    
    return [ASIDownloadCache sharedCache];
    
}

- (NSString *)compoundPredicateKey {
    
    return [[self.compoundPredicate predicateFormat] md5];
    
}

- (void)setLastPerformDate:(NSDate *)value {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:value forKey:[NSString stringWithFormat:@"DKRestQuery/%@", [self compoundPredicateKey]]];
    [userDefaults synchronize];
    
}

- (NSDate *)lastPerformDate {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    return (NSDate *)[userDefaults valueForKey:[NSString stringWithFormat:@"DKRestQuery/%@", [self compoundPredicateKey]]];
    
}

- (void)dealloc {
    
    [downloadCache release];
    
    [super dealloc];
    
}

@end