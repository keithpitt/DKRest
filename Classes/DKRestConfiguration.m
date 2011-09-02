//
//  DKRestConfiguration.m
//  DKRest
//
//  Created by Keith Pitt on 1/09/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestConfiguration.h"

#import "NSString+Inflections.h"
#import "DKRestServer.h"
#import "DKRestObject.h"

@implementation DKRestConfiguration

@synthesize restServer, resourcePathBlock, resourceName, primaryKey, postParametersBlock,
            resourceFromDataObject, resourceVersion;

- (id)init {
    
    if ((self = [super init])) {
        
        // Set the default server
        [self server:[DKRestServer defaultServer]];
        
        ignoredParameters = [[NSMutableArray alloc] init];
        parameterMapping = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
    
}

- (id)initWithRestClass:(Class)klass {
    
    if ((self = [self init])) {
        
        restClass = klass;
        
        // Setup the default resource name
        
        NSString * name = [[[restClass description] lowercaseString] singularize];
        
        [self resourceName:name];
        
        // Default resource name
        
        [self resourcePathWithBlock:^(DKRestObject * restObject) {
            
            // If we have a rest object, construct a "users/1" like URL,
            // otherwise, "users" will be returned.
            
            NSString * pluralizedResourceName = [self.resourceName pluralize];
            
            if (restObject) {
                
                NSString * identifier = [NSString stringWithFormat:@"%@", [restObject valueForKey:self.primaryKey]];
                return [pluralizedResourceName stringByAppendingPathComponent:identifier];
                
            } else {
                
                return pluralizedResourceName;
                
            }
            
        }];
        
        // Default primary key
        
        [self primaryKey:@"identifier"];
        
        // Default resource from data object method
        
        [self resourceFromDataObject:^(NSDictionary * data) {
            
            // Grab the attributes
            NSDictionary * attributes = [data objectForKey:resourceName];
            
            // Create the rest object
            DKRestObject * object = [restClass new];
            
            // Create a rest resource
            [object setAttributes:attributes];
            
            return object;
            
        }];
        
        // Defualt property list
        
        [self postParameters:^(DKRestObject * object) {
            
            return [object attributesWithMappingRules:parameterMapping andIgnoreProperties:ignoredParameters];

        }];
        
    }
    
    return self;
    
}

- (void)server:(DKRestServer *)server {
    
    restServer = [server retain];
    
}

- (void)resourceName:(NSString *)name {
    
    if (resourceName)
        [resourceName release];
    
    resourceName = [name copy];
    
}

- (void)resourceVersion:(NSString *)version {
    
    if (resourceVersion)
        [resourceVersion release];
    
    resourceVersion = [version copy];
    
}

- (void)primaryKey:(NSString *)key {
    
    if (primaryKey)
        [primaryKey release];
    
    primaryKey = [key copy];
    
}

- (void)resourcePath:(NSString *)path {
    
    NSString * resourcePath = [path copy];

    [self resourcePathWithBlock:^(DKRestObject * restObject) {
        
        // If we have a rest object, construct a "users/1" like URL,
        // otherwise, "users" will be returned.
        
        if (restObject) {
            
            NSString * identifier = [NSString stringWithFormat:@"%@", [restObject valueForKey:primaryKey]];
            return [resourcePath stringByAppendingPathComponent:identifier];
            
        } else {
            
            return resourcePath;
            
        }
        
    }];

}

- (void)resourcePathWithBlock:(DKRestResourcePathBlock)block {

    // If we already have a resource path block
    if (resourcePathBlock)
        Block_release(resourcePathBlock);

    resourcePathBlock = Block_copy(block);

}

- (void)postParameters:(DKRestParametersBlock)block {
    
    // If we already have a parameters block
    if (postParametersBlock)
        Block_release(postParametersBlock);
    
    postParametersBlock = Block_copy(block);
    
}

- (void)ignoreProperty:(NSString *)property {
    
    [self mapProperty:property toParameter:nil];
    
}

- (void)mapProperty:(NSString *)property toParameter:(NSString *)param {
    
    [self mapProperty:property toParameter:param nestObjects:NO];
    
}

- (void)mapProperty:(NSString *)property toParameter:(NSString *)param nestObjects:(BOOL)nestObjects {
    
    // If passing "nil", you are effectivley ignoring the mapping
    if (!param) {
        
        [ignoredParameters addObject:property];
        
    } else {
        
        NSMutableDictionary * definition = [NSMutableDictionary dictionaryWithObject:param forKey:@"parameter"];
        
        if (nestObjects)
            [definition setValue:@"YES" forKey:@"nestObjects"];
        
        [parameterMapping setObject:definition forKey:property];
        
    }
    
}

- (void)resourceFromDataObject:(DKRestResourceFromObjectBlock)block {
    
    // If we already have a properties block
    if (resourceFromDataObject)
        Block_release(resourceFromDataObject);
    
    resourceFromDataObject = Block_copy(block);
    
}

- (void)dealloc {
    
    [parameterMapping release];
    [ignoredParameters release];
    
    [primaryKey release];
    [restServer release];
    [resourceName release];
    
    Block_release(resourcePathBlock);
    Block_release(postParametersBlock);
    Block_release(resourceFromDataObject);
}

@end