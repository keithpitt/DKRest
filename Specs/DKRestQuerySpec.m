//
//  DKRestQuerySpec.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "SpecHelper.h"

#import "DKRestQuery.h"
#import "FGSpecUser.h"

#import "DKRestObject.h"
#import "DKFile.h"
#import "DKAPIResponse.h"
#import "DKAPIStub.h"
#import "DKAPIRequest.h"

SPEC_BEGIN(DKRestQuerySpec)

__block DKRestQuery * restQuery;

beforeEach(^{
    
    restQuery = [[DKRestQuery alloc] init];
    
    [restQuery where:@"name" equals:@"keith"];
    [restQuery where:@"count" greaterThan:[NSNumber numberWithInt:12]];
    [restQuery where:@"username" isNull:NO];
    
});

context(@"-compoundPredicateKey", ^{
    
    it(@"should return a unique key for the predicate", ^{
        
        expect([restQuery compoundPredicateKey]).toEqual(@"06B2D8BB9C2B5EE01FA4D70C3D06F8E0");
        
    });
    
});

context(@"lastPerformDate", ^{
    
    it(@"should return the last perform date", ^{
        
        NSDate * now = [NSDate date];
        [restQuery setLastPerformDate:now];
        
        expect(restQuery.lastPerformDate).toEqual(now);
        
    });
    
});

describe(@"-perform:error:cache:", ^{
    
    it(@"should download results and store them in core data", ^{
        
        NSArray * users = [[DKFile jsonFromBundle:nil pathForResource:@"UsersWithNameKeithPitt"] retain];
        
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