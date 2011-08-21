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
#import "DKAPIRequestStub.h"
#import "DKAPIResponse.h"

SPEC_BEGIN(DKRestObjectQuerySpec)

describe(@"DKRestObjectQuerySpec", ^{
    
    __block NSArray * users;
    __block NSDictionary * json;
    
    beforeEach(^{
        
        users = [[DKFile jsonFromBundle:nil pathForResource:@"UsersWithNameKeithPitt"] retain];
        
        json = [NSDictionary dictionaryWithObject:users forKey:@"response"];
         
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
            [DKAPIRequest stubNextRequest:[DKAPIRequestStub requestStubWithBlock:^(ASIFormDataRequest * formRequest) {
                
                expect([formRequest.url absoluteString]).toEqual(@"http://api.example.com/v1/dkrestobjects?first_name=Keith&last_name=Pitt");
                
                return [DKAPIResponse responseWithJSON:json success:YES];
                
            }]];
            
            [restQuery perform:^(NSArray * records) {
                completed = YES;
                results = [records retain];
            } error:^(NSError * error) {
                completed = YES;
            } cache:YES];
            
            while(!completed)
                [NSThread sleepForTimeInterval:0.1];
            
            expect([results count]).toEqual(10);
            
            expect(restQuery.lastPerformDate).Not.toBeNil();
            
        });
        
    });

});

SPEC_END