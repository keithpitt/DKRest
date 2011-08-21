//
//  DKRestObject.m
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject.h"

#import "DKAPIRequest.h"
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

+ (DKAPIRequest *)request:(NSString *)path
                     data:(NSDictionary *)data
                   object:(id)object
                 selector:(SEL)selector
                 complete:(DKAPIRequestSuccessCallback)completeBlock
                    error:(DKAPIRequestErrorCallback)errorBlock
           uploadDelegate:(id)uploadDelegate
         downloadDelegate:(id)downloadDelegate {
    
    DKAPIRequest * request = [DKAPIRequest new];
    
    // Generate a url
    NSURL * url = [[self router] routeFor:object withPath:path];
    
    // Set properties about the request
    request.data = data;
    request.successCallback = completeBlock;
    request.errorCallback = errorBlock;
    request.uploadProgressDelegate = uploadDelegate;
    request.downloadProgressDelegate = downloadDelegate;
    
    [request performSelector:selector withObject:[url absoluteString]];
    
    return [request autorelease];
    
}

+ (DKAPIRequest *)get:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [self request:path data:data object:self selector:@selector(get:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

+ (DKAPIRequest *)get:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate {
    
    return [self request:path data:data object:self selector:@selector(get:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
}

+ (DKAPIRequest *)post:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [self request:path data:data object:self selector:@selector(post:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

+ (DKAPIRequest *)post:(NSString *)path
                  data:(NSDictionary *)data 
              complete:(DKAPIRequestSuccessCallback)completeBlock
                 error:(DKAPIRequestErrorCallback)errorBlock
        uploadDelegate:(id)uploadDelegate
      downloadDelegate:(id)downloadDelegate {
    
    return [self request:path data:data object:self selector:@selector(post:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
}

+ (DKAPIRequest *)put:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [self request:path data:data object:self selector:@selector(put:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

+ (DKAPIRequest *)put:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate {
    
    return [self request:path data:data object:self selector:@selector(put:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
}

+ (DKAPIRequest *)delete:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [self request:path data:data object:self selector:@selector(delete:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

+ (DKAPIRequest *)delete:(NSString *)path
                    data:(NSDictionary *)data
                complete:(DKAPIRequestSuccessCallback)completeBlock
                   error:(DKAPIRequestErrorCallback)errorBlock
          uploadDelegate:(id)uploadDelegate
        downloadDelegate:(id)downloadDelegate {
    
    return [self request:path data:data object:self selector:@selector(delete:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
}

- (DKAPIRequest *)get:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [[self class] request:path data:data object:self selector:@selector(get:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

- (DKAPIRequest *)get:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate {
    
    return [[self class] request:path data:data object:self selector:@selector(get:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
}

- (DKAPIRequest *)post:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [[self class] request:path data:data object:self selector:@selector(post:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

- (DKAPIRequest *)post:(NSString *)path
                  data:(NSDictionary *)data
              complete:(DKAPIRequestSuccessCallback)completeBlock
                 error:(DKAPIRequestErrorCallback)errorBlock
        uploadDelegate:(id)uploadDelegate
      downloadDelegate:(id)downloadDelegate {
    
    return [[self class] request:path data:data object:self selector:@selector(post:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
}

- (DKAPIRequest *)put:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [[self class] request:path data:data object:self selector:@selector(put:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

- (DKAPIRequest *)put:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate {
    
    return [[self class] request:path data:data object:self selector:@selector(put:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
}

- (DKAPIRequest *)delete:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [[self class] request:path data:data object:self selector:@selector(delete:) complete:completeBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

- (DKAPIRequest *)delete:(NSString *)path
                    data:(NSDictionary *)data
                complete:(DKAPIRequestSuccessCallback)completeBlock
                   error:(DKAPIRequestErrorCallback)errorBlock
          uploadDelegate:(id)uploadDelegate
        downloadDelegate:(id)downloadDelegate {
    
    return [[self class] request:path data:data object:self selector:@selector(delete:) complete:completeBlock error:errorBlock uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
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

- (DKAPIRequest *)save:(DKAPIRequestSuccessCallback)successBlock error:(DKAPIRequestErrorCallback)errorBlock {
    
    return [self save:successBlock error:errorBlock uploadDelegate:nil downloadDelegate:nil];
    
}

- (DKAPIRequest *)save:(DKAPIRequestSuccessCallback)successBlock error:(DKAPIRequestErrorCallback)errorBlock uploadDelegate:(id)uploadDelegate downloadDelegate:(id)downloadDelegate {
    
    // While we're saving, hold onto the object
    [self retain];
    
    bool wasPersisted = [self isPersisted];
    
    if (!wasPersisted)
        [self beforeCreate];
    else
        [self beforeUpdate];
    
    [self beforeSave];
    
    NSDictionary * data = [NSDictionary dictionaryWithObject:[self attributesToPost] forKey:[[self class] resourceName]];
    
    DKAPIRequest * request = [self post:nil data:data complete:^(DKAPIResponse * response) {
        
        [self afterSave:response];
        
        if (!wasPersisted)
            [self afterCreate:response];
        else
            [self afterUpdate:response];
        
        successBlock(response);
        
        [self release];
        
    } error:^(DKAPIResponse * response) {
        
        errorBlock(response);
        
        [self release];
        
    } uploadDelegate:uploadDelegate downloadDelegate:downloadDelegate];
    
    return request;
    
}

@end