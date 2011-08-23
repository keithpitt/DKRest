//
//  DKRestObject.m
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject.h"

#import "DKAPIRequest.h"
#import "DKAPIResponse.h"
#import "DKRestRouter.h"

#import "objc/runtime.h"
#import "NSString+Inflections.h"

@implementation DKRestObject

+ (id<DKRestRouterProtocol>)router {
    
    // Return an instance of the deafult router.
    return [DKRestRouter defaultRouter];
    
}

+ (NSString *)resourceName {
    
    return [[[[self class] description] lowercaseString] singularize];
    
}

+ (NSString *)resourcePath {
    
    return [[self resourceName] pluralize];
    
}

+ (DKRestQuery *)query {
    
    return [[[DKRestQuery alloc] initWithClass:self] autorelease];
    
}

+ (DKRestQuery *)search {
    
    return [self searchWithPath:[self resourcePath]];
    
}

+ (DKRestQuery *)searchWithPath:(NSString *)path {
    
    DKRestQuery * restQuery = [[DKRestQuery alloc] initWithClass:self];
    restQuery.search = YES;
    
    return [restQuery autorelease];
    
}

+ (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod {
    
    NSURL * url = [[self router] routeFor:self withPath:path];

    DKAPIRequest * request = [[DKAPIRequest alloc] initWithURL:url
                                                 requestMethod:requestMethod
                                                    parameters:nil];
    
    return [request autorelease];
    
}

- (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod {
    
    NSURL * url = [[[self class] router] routeFor:self withPath:path];
    
    DKAPIRequest * request = [[DKAPIRequest alloc] initWithURL:url
                                                 requestMethod:requestMethod
                                                    parameters:nil];
    
    return [request autorelease];
    
}

- (void)setId:(id)identifier {
    
    [self setValue:identifier forKey:@"identifier"];
    
}

- (BOOL)isPersisted {
    
    return [self performSelector:@selector(identifier)] != nil;
    
}

- (void)beforeCreate {
    
    // Do nothing. Overwrite in subclass.
    
}

- (void)beforeUpdate {
    
    // Do nothing. Overwrite in subclass.
    
}

- (void)beforeSave {
    
    // Do nothing. Overwrite in subclass.
    
}

- (void)afterCreate:(DKAPIResponse *)response {
    
    // Do nothing. Overwrite in subclass.
    
}

- (void)afterUpdate:(DKAPIResponse *)response {
    
    // Do nothing. Overwrite in subclass.
    
}

- (void)afterSave:(DKAPIResponse *)response {
    
    NSDictionary * updatedAttributes = [response.data objectForKey:[[self class] resourceName]];
    
    if (updatedAttributes)
        [self setAttributes:updatedAttributes];
    
}

- (NSDictionary *)attributesToPost {
    
    return [self attributes];
    
}

- (NSDictionary *)attributes {
    
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    
    unsigned int propertyCount, i;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    
    for (i = 0; i < propertyCount; i++) {        
        
        objc_property_t property = properties[i];
        
        NSString * propertyName = [NSString stringWithCString:property_getName(property)
                                                     encoding:NSASCIIStringEncoding];
        
        NSString * attributeName = [propertyName underscore];
        
        id value = [self valueForKey:propertyName];
        
        // If the property is another DKRestObject
        if ([value isKindOfClass:[DKRestObject class]]) {
            
            attributeName = [attributeName stringByAppendingFormat:@"_id"];
            [attributes setValue:[value valueForKey:@"identifier"] forKey:attributeName];
            
        } else {
            
            [attributes setValue:value forKey:attributeName];
            
        }
        
    }
    
    return attributes;
    
}

- (void)setAttributes:(NSDictionary *)attributes {
    
    NSArray * keys = [attributes allKeys];
    
    for (NSString * key in keys) {
        
        NSString * propertySetter = [NSString stringWithFormat:@"set%@:", [key camelize]];
        SEL propertySetterSelector = NSSelectorFromString(propertySetter);
        
        if ([self respondsToSelector:propertySetterSelector])    
            [self performSelector:propertySetterSelector withObject:[attributes valueForKey:key]];
        
    }
    
}

- (DKAPIRequest *)save:(DKAPIRequestFinishBlock)finishBlock {
    
    return [self save:finishBlock delegate:nil];
    
}

- (DKAPIRequest *)save:(DKAPIRequestFinishBlock)finishBlock delegate:(id)delegate {
    
    // While we're saving, hold onto the object
    [self retain];
    
    bool persisted = [self isPersisted];
    
    if (!persisted)
        [self beforeCreate];
    else
        [self beforeUpdate];
    
    [self beforeSave];
    
    // Create the request
    DKAPIRequest * request = [[self class] requestWithPath:@"" requestMethod:@"POST"];
    
    // request.delegate = delegate;
    
    // Add params
    request.parameters = [NSDictionary dictionaryWithObject:[self attributesToPost] forKey:[[self class] resourceName]];
    
    // Add the finish block
    request.finishBlock = ^(DKAPIResponse * response, NSError * error) {
        
        // Successs?
        if (response) {
            
            // Call the after save callback
            [self afterSave:response];
            
            // Switch between afterCreate and afterUpdate
            if (!persisted)
                [self afterCreate:response];
            else
                [self afterUpdate:response];
            
        }
        
        finishBlock(response, error);
        
        [self release];
        
    };
    
    // Start the request
    [request startAsynchronous];
    
    return request;
    
}

@end