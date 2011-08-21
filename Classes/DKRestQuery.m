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
#import "NSString+Inflections.h"

@implementation DKRestQuery

@synthesize restClass, successBlock, errorBlock, search, downloadCache;

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

- (void)perform:(DKQueryPerformSuccess)success error:(DKQueryPerformError)error {
    
    [self perform:success error:error cache:NO uploadDelegate:nil downloadDelegate:nil];
    
}

- (void)perform:(DKQueryPerformSuccess)success error:(DKQueryPerformError)error cache:(BOOL)cache {
    
    [self perform:success error:error cache:cache uploadDelegate:nil downloadDelegate:nil];
    
}

- (void)perform:(DKQueryPerformSuccess)success error:(DKQueryPerformError)error cache:(BOOL)cache uploadDelegate:(id)uploadDelegate downloadDelegate:(id)downloadDelegate {
    
    [self retain];
    
    // Copy the success block (we should always have one)
    self.successBlock = Block_copy(success);
    
    // If there is a error block
    if (error)
        self.errorBlock = Block_copy(error);
    
    // Create a new API request
    DKAPIRequest * request = [DKAPIRequest new];
    
    // Set the post data.
    // TODO: This should toggle between simple and meta search
    if (self.search) {
        request.data = [self metaSearchPostData];
    } else {
        request.data = [self simplePostData];
    }
    
    request.uploadProgressDelegate = uploadDelegate;
    request.downloadProgressDelegate = downloadDelegate;
    
    request.cachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    request.downloadCache = self.downloadCache;
    
    // The success callback
    request.successCallback = ^(DKAPIResponse * response) {
        
        // The response data
        NSArray * data = (NSArray*)response.data;
        
        // Run the success block with the rest resources
        NSArray * resources = [self convertToRestResources:data];
        
        void (^finished)(void) = ^ {
            
            // Call the success block with the resources
            self.successBlock(resources);
            
            // Release the request
            [request release];
            
            // Release ourself
            [self release];
            
            // Last sync date
            [self setLastPerformDate:[NSDate date]];
            
        };
        
        if (cache) {
            
            // Start importing the data
            [self importData:data success:finished];
            
        } else {
            
            // Lets just finish up
            finished();
            
        }
        
    };
    
    // The error callback
    request.errorCallback = ^(DKAPIResponse * response) {
        
        // Call the failure block with the response if we have one
        if (self.errorBlock) {
            self.errorBlock(response.error);
        }
        
        // Release the request
        [request release];
        
        // Release self
        [self release];
        
    };
    
    // Grab the URL for the resource
    id router = [self.restClass performSelector:@selector(router)];
    
    // Find the URL to post to
    NSURL * url = [router performSelector:@selector(routeFor:) withObject:restClass];
    
    // Perform the request
    [request get:[url absoluteString]];
    
}

- (ASIDownloadCache *)downloadCache {
    
    if (!downloadCache) {
        NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        downloadCache = [[ASIDownloadCache alloc] init];
        downloadCache.storagePath = [NSString stringWithFormat:@"%@/%@", rootPath, [self compoundPredicateKey]];
    }
    
    return [ASIDownloadCache sharedCache];
    
}

- (void)dealloc {
    
    [downloadCache release];
    
    [super dealloc];
    
}

@end