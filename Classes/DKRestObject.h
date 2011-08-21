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

+ (DKAPIRequest *)get:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
+ (DKAPIRequest *)get:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate;

+ (DKAPIRequest *)post:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
+ (DKAPIRequest *)post:(NSString *)path
                  data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate;

+ (DKAPIRequest *)put:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
+ (DKAPIRequest *)put:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate;

+ (DKAPIRequest *)delete:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
+ (DKAPIRequest *)delete:(NSString *)path
                    data:(NSDictionary *)data
                complete:(DKAPIRequestSuccessCallback)completeBlock
                   error:(DKAPIRequestErrorCallback)errorBlock
          uploadDelegate:(id)uploadDelegate
        downloadDelegate:(id)downloadDelegate;


- (DKAPIRequest *)get:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
- (DKAPIRequest *)get:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate;

- (DKAPIRequest *)post:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
- (DKAPIRequest *)post:(NSString *)path
                  data:(NSDictionary *)data
              complete:(DKAPIRequestSuccessCallback)completeBlock
                 error:(DKAPIRequestErrorCallback)errorBlock
        uploadDelegate:(id)uploadDelegate
      downloadDelegate:(id)downloadDelegate;

- (DKAPIRequest *)put:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
- (DKAPIRequest *)put:(NSString *)path
                 data:(NSDictionary *)data
             complete:(DKAPIRequestSuccessCallback)completeBlock
                error:(DKAPIRequestErrorCallback)errorBlock
       uploadDelegate:(id)uploadDelegate
     downloadDelegate:(id)downloadDelegate;

- (DKAPIRequest *)delete:(NSString *)path data:(NSDictionary *)data complete:(DKAPIRequestSuccessCallback)completeBlock error:(DKAPIRequestErrorCallback)errorBlock;
- (DKAPIRequest *)delete:(NSString *)path
                    data:(NSDictionary *)data
                complete:(DKAPIRequestSuccessCallback)completeBlock
                   error:(DKAPIRequestErrorCallback)errorBlock
          uploadDelegate:(id)uploadDelegate
         downloadDelegate:(id)downloadDelegate;

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

- (DKAPIRequest *)save:(DKAPIRequestSuccessCallback)successBlock error:(DKAPIRequestErrorCallback)errorBlock;
- (DKAPIRequest *)save:(DKAPIRequestSuccessCallback)successBlock error:(DKAPIRequestErrorCallback)errorBlock uploadDelegate:(id)uploadDelegate downloadDelegate:(id)downloadDelegate;

@end