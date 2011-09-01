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
#import "DKRestServer.h"

#import "objc/runtime.h"
#import "NSString+Inflections.h"

@implementation DKRestObject

static DKRestConfiguration * resourceConfiguration;

+ (DKRestConfiguration *)resourceConfiguration {
    
    if (!resourceConfiguration) {
        resourceConfiguration = [[DKRestConfiguration alloc] initWithRestClass:self];
        [self configureResource:resourceConfiguration];
    }
    
    return resourceConfiguration;
    
}

+ (void)configureResource:(DKRestConfiguration *)config {
    
    // This does nothing by default. This can be overridden by the sub
    // class to do other config.
    
}

+ (DKRestQuery *)query {
    
    DKRestConfiguration * config = [self resourceConfiguration];
    
    return [self queryWithPath:config.resourcePathBlock(nil)];
    
}

+ (DKRestQuery *)queryWithPath:(NSString *)path {
    
    DKRestConfiguration * config = [self resourceConfiguration];
    
    NSURL * url = [[NSURL URLWithString:config.restServer.host] URLByAppendingPathComponent:path];
    
    DKRestQuery * query = [[DKRestQuery alloc] initWithClass:self url:url];
    
    return [query autorelease];
    
}

+ (DKRestQuery *)search {
    
    // Generate a query
    DKRestQuery * query = [self query];
    
    // Use search query syntax
    query.search = YES;
    
    return query;
    
}

+ (DKRestQuery *)searchWithPath:(NSString *)path {
    
    // Generate a query
    DKRestQuery * query = [self queryWithPath:path];
    
    // Use search query syntax
    query.search = YES;
    
    return query;
    
}

+ (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod {
    
    DKRestConfiguration * config = [self resourceConfiguration];
    
    NSString * resourcePath = [config.resourcePathBlock(nil) stringByAppendingPathComponent:path];
    
    NSURL * url = [[NSURL URLWithString:config.restServer.host] URLByAppendingPathComponent:resourcePath];

    DKAPIRequest * request = [[DKAPIRequest alloc] initWithURL:url
                                                 requestMethod:requestMethod
                                                    parameters:nil];
    
    return [request autorelease];
    
}

- (DKAPIRequest *)requestWithPath:(NSString *)path requestMethod:(NSString *)requestMethod {
    
    DKRestConfiguration * config = [[self class] resourceConfiguration];
    
    NSString * resourcePath = [config.resourcePathBlock(self) stringByAppendingPathComponent:path];
    
    NSURL * url = [[NSURL URLWithString:config.restServer.host] URLByAppendingPathComponent:resourcePath];
    
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
    
    DKRestConfiguration * config = [[self class] resourceConfiguration];
    
    NSDictionary * updatedAttributes = [response.data objectForKey:config.resourceName];
    
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
        
        [attributes setValue:[self valueForKey:propertyName]
                      forKey:[propertyName underscore]];
        
    }
    
    return attributes;
    
}

- (id)formData:(DKAPIFormData *)formData valueForParameter:(NSString *)key {
    
    return [self valueForKey:@"identifier"];
    
}

- (NSString *)formData:(DKAPIFormData *)formData parameterForKey:(NSString *)key {
    
    if ([key hasSuffix:@"]"])
        return [key stringByReplacingCharactersInRange:NSMakeRange([key length] - 1, 1) withString:@"_id]"];    
    else
        return [key stringByAppendingString:@"_id"];
    
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
    
    // Rest configuration
    DKRestConfiguration * config = [[self class] resourceConfiguration];
    
    // Create the request
    DKAPIRequest * request = [[self class] requestWithPath:@"" requestMethod:@"POST"];
    
    // request.delegate = delegate;
    
    // Add params
    request.parameters = [NSDictionary dictionaryWithObject:[self attributesToPost] forKey:config.resourceName];
    
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