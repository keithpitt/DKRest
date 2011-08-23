//
//  FGRelRouterSpec.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "SpecHelper.h"
#import "FGSpecRemoteUser.h"

#import "DKRestRouter.h"

SPEC_BEGIN(DKAPIRouterSpec)

__block DKRestRouter * router;

beforeEach(^{
    router = [DKRestRouter new];
    router.host = @"api.example.com";
    router.version = @"1";
    router.ssl = NO;
});

describe(@"-resourceFor", ^{
    
    it(@"should return the correct resource for classes", ^{
        
        NSURL * url = [router routeFor:[FGSpecRemoteUser class]];
        
        expect([url absoluteString]).toEqual(@"http://api.example.com/v1/users");
        
    });
    
    it(@"should return the correct resource for instances", ^{
        
        FGSpecRemoteUser * user = [FGSpecRemoteUser new];
        user.identifier = [NSNumber numberWithInt:12];
        
        NSURL * url = [router routeFor:user];
        
        expect([url absoluteString]).toEqual(@"http://api.example.com/v1/users/12");
        
    });
    
});

SPEC_END