//
//  DKRestObjectQuerySpec.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "SpecHelper.h"

#import "FGSpecUser.h"

#import "DKRestObject.h"
#import "DKFile.h"
#import "DKAPIResponse.h"
#import "DKAPIStub.h"
#import "DKAPIRequest.h"

SPEC_BEGIN(DKRestObjectQuerySpec)

__block NSArray * users;

beforeEach(^{
    
    users = [[DKFile jsonFromBundle:nil pathForResource:@"UsersWithNameKeithPitt"] retain];
     
});

describe(@"-perform:error:cache:", ^{
    
    it(@"should download results and store them in core data", ^{
        
        [FGSpecUser destroyAll];
        
        __block BOOL completed = NO;
        __block NSArray * results;
        
        DKRestQuery * restQuery = [DKRestObject query];
        
        [restQuery where:@"firstName" equals:@"Keith"];
        [restQuery where:@"lastName" equals:@"Pitt"];
        
        // Stub the next API request
        [DKAPIStub stubWithBlock:^(DKAPIRequest * apiRequest) {
            
            expect([apiRequest.formDataRequest.url absoluteString]).toEqual(@"http://api.example.com/v1/dkrestobjects?first_name=Keith&last_name=Pitt");
            
            return [DKAPIResponse responseWithStatus:@"ok" data:users errors:nil];
                        
        }];
        
        [restQuery perform:^(NSArray * records, NSError * error) {
            
            completed = YES;
            results = [records retain];
            
            expect(error).toBeNil();
            
        } cacheStrategy:DKRestCacheStrategyCoreData];
        
        while(!completed)
            [NSThread sleepForTimeInterval:0.1];
        
        expect([results count]).toEqual(10);
        
        expect(restQuery.lastPerformDate).Not.toBeNil();
        
    });
    
});

SPEC_END