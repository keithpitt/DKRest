//
//  DKRestConfiguration.h
//  DKRest
//
//  Created by Keith Pitt on 1/09/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DKRestObject;
@class DKRestServer;

typedef NSString * (^DKRestResourcePathBlock)(id);
typedef NSDictionary * (^DKRestParametersBlock)(id);
typedef DKRestObject * (^DKRestResourceFromObjectBlock)(NSDictionary *);

@interface DKRestConfiguration : NSObject {
    
    Class restClass;

}

@property (nonatomic, readonly) DKRestServer * restServer;
@property (nonatomic, readonly) NSString * resourceName;
@property (nonatomic, readonly) NSString * resourceVersion;
@property (nonatomic, readonly) NSString * primaryKey;

@property (nonatomic, readonly) DKRestResourcePathBlock resourcePathBlock;
@property (nonatomic, readonly) DKRestParametersBlock postParametersBlock;
@property (nonatomic, readonly) DKRestResourceFromObjectBlock resourceFromDataObject;

- (id)initWithRestClass:(Class)klass;

- (void)server:(DKRestServer *)server;

- (void)resourceName:(NSString *)name;

- (void)resourceVersion:(NSString *)version;

- (void)primaryKey:(NSString *)key;

- (void)resourcePath:(NSString *)path;
- (void)resourcePathWithBlock:(DKRestResourcePathBlock)block;

- (void)postParameters:(DKRestParametersBlock)block;

- (void)mapProperty:(NSString *)property toParameter:(NSString *)param;
- (void)mapProperty:(NSString *)property toParameter:(NSString *)param nestObjects:(BOOL)nestObjects;

- (void)resourceFromDataObject:(DKRestResourceFromObjectBlock)block;

@end